--KYOUTOUウォーターフロント
function c7000.initial_effect(c)
	c:EnableCounterPermit(0x80)
	c:SetCounterLimit(0x80,99)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--auto activate	
	local e2=Effect.CreateEffect(c)
	c7000[0]=0	
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCountLimit(1,7000+EFFECT_COUNT_CODE_DUEL)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetOperation(c7000.op)
	c:RegisterEffect(e2)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c7000.acop)
	c:RegisterEffect(e2)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(7000,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c7000.target)
	e5:SetOperation(c7000.activate)
	c:RegisterEffect(e5)
end
function c7000.thfilter(c)
	return c:IsSetCard(0x444)  and c:IsAbleToHand()
end
function c7000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7000.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c7000.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c7000.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c7000.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x80,4,true)
	end
end

function c7000.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetDecktopGroup(tp,dc)
	local i
	g:GetFirst():RegisterFlagEffect(7000,0,0,1)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	Duel.ShuffleDeck(tp)
	local seq=g:GetFirst():GetSequence()
	Duel.RegisterFlagEffect(tp,7000,0,0,seq)
	c7000[tp]=seq
	local sd=Duel.GetMatchingGroup(c7000.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.SendtoDeck(sd,nil,-2,REASON_RULE)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1<5 then
		Duel.Draw(tp,5-ht1,REASON_RULE)
	end
end