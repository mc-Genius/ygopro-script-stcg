--Sin World
function c9001.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--auto activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,9001+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetOperation(c9001.op)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27564031,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9001.thcon)
	e2:SetTarget(c9001.thtg)
	e2:SetOperation(c9001.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c9001.descon)
	e3:SetTarget(c9001.atktg)
	c:RegisterEffect(e3)
	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c9001.efilter)
	c:RegisterEffect(e4)
end
function c9001.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9001.rfilter(c)
	return c:IsCode(9001)
end
function c9001.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.ShuffleDeck(tp)
	local sd=Duel.GetMatchingGroup(c9001.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.SendtoDeck(sd,nil,-2,REASON_RULE)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1<5 then
		Duel.Draw(tp,5-ht1,REASON_RULE)
	end
end
function c9001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c9001.filter(c)
	return c:IsSetCard(0x23)  and c:IsAbleToHand()
end
function c9001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9001.filter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9001.thop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c9001.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c9001.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c9001.descon(e)
	return Duel.IsExistingMatchingCard(c9001.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9001.atktg(e,c)
	return not c:IsSetCard(0x23)
end
