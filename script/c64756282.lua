--ウィッチクラフト・ジェニー

--Scripted by mallu11
function c64756282.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64756282,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,64756282)
	e1:SetCondition(c64756282.spcon)
	e1:SetCost(c64756282.spcost)
	e1:SetTarget(c64756282.sptg)
	e1:SetOperation(c64756282.spop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64756282,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101011121)
	e2:SetCost(c64756282.cpcost)
	e2:SetTarget(c64756282.cptg)
	e2:SetOperation(c64756282.cpop)
	c:RegisterEffect(e2)
end
function c64756282.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c64756282.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c64756282.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64756282.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c64756282.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(83289866,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c64756282.spfilter(c,e,tp)
	return c:IsSetCard(0x128) and not c:IsCode(64756282) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64756282.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c64756282.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c64756282.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c64756282.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c64756282.cpfilter(c)
	local b=c:IsSetCard(0x128) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
	local te=c:CheckActivateEffect(false,true,false)
	if te~=nil then
		local op=te:GetOperation()
		return b and op~=nil
	end
	return false
end
function c64756282.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c64756282.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c64756282.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(false,true,true)
	c64756282[Duel.GetCurrentChain()]=te
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c64756282.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c64756282[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c64756282.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=c64756282[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
