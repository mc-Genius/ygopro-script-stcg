--
--Boot-Up Corporal - Command Dynamo
--Scripted by AlphaKretin
function c100255001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100255001.,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100255001.)
	e1:SetTarget(c100255001.sptg)
	e1:SetOperation(c100255001.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100255001.atkval)
	c:RegisterEffect(e2)
end
c100255001.listed_series={0x51}
function c100255001.eqfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x51) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c100255001.eqfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x51) and c:IsRace(RACE_MACHINE) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp)
end
function c100255001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c100255001.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(aux.dncheck,1,ft)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SetTargetCard(sg)
	local tg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if tg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tg,tg:GetCount(),0,0)
	end
end
function c100255001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local g=Duel.GetTargetCards(e)
		g=g:Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsType,nil,TYPE_MONSTER):Filter(Card.IsSetCard,nil,0x51)
		if ft<#g then return end
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			Duel.Equip(tp,tc,c,false)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c100255001.eqlimit)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(100255001.,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function c100255001.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100255001.atkfilter(c)
	return c:GetFlagEffect(100255001.)~=0
end
function c100255001.atkval(e,c)
	return c:GetEquipGroup():FilterCount(c100255001.atkfilter,nil)*1000
end

