--ラクガキ・エゴイスト
function c7020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92204263,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c7020.spcost)
	e1:SetTarget(c7020.sptg)
	e1:SetOperation(c7020.spop)
	c:RegisterEffect(e1)
end
function c7020.costfilter(c,e,tp)
	return
		Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c7020.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c7020.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c7020.costfilter,1,nil,e,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c7020.costfilter,1,1,nil,e,tp)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.Release(sg,REASON_COST)
end
function c7020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c7020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7020.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

