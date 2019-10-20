--塊斬機ダランベルシアン
--Batch Processlayer d'Alembertian
--Scripted by AlphaKretin
function c100200170.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200170.,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100200170.)
	e1:SetCondition(c100200170.thcon)
	e1:SetCost(c100200170.thcost)
	e1:SetTarget(c100200170.thtg)
	e1:SetOperation(c100200170.thop)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200170.,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,100200170.+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100200170.spcost)
	e2:SetTarget(c100200170.sptg)
	e2:SetOperation(c100200170.spop)
	c:RegisterEffect(e2)
end
c100200170.listed_series={0x231}
function c100200170.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c100200170.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mm=c100200170.mmtg(e,tp,eg,ep,ev,re,r,rp,0) --"Mathmech" target
	local l4=c100200170.l4tg(e,tp,eg,ep,ev,re,r,rp,0) --"Level 4" target
	local st=c100200170.sttg(e,tp,eg,ep,ev,re,r,rp,0) --"Spell/Trap" target
	local ct
	if st then ct = 4 end
	if l4 then ct = 3 end
	if mm then ct = 2 end
	if chk==0 then return (hand or mon or st) and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	local selections={}
	if st and c:CheckRemoveOverlayCard(tp,4,REASON_COST) then
		table.insert(selections,4)
	end
	if l4 and c:CheckRemoveOverlayCard(tp,3,REASON_COST) then
		table.insert(selections,3)
	end
	if mm and c:CheckRemoveOverlayCard(tp,2,REASON_COST) then
		table.insert(selections,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sel=Duel.AnnounceNumber(tp,table.unpack(selections))
	c:RemoveOverlayCard(tp,sel,sel,REASON_COST)
	if sel==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(100200170.,1))
	elseif sel==3 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(100200170.,2))
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(100200170.,3))
	end
	e:SetLabel(sel)
end
function c100200170.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end --legality handled in cost by necessity
	local sel=e:GetLabel()
	if sel==2 then
		c100200170.mmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	elseif sel==3 then
		c100200170.l4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	else
		c100200170.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c100200170.thop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==2 then
		c100200170.mmop(e,tp,eg,ep,ev,re,r,rp)
	elseif sel==3 then
		c100200170.l4op(e,tp,eg,ep,ev,re,r,rp)
	else
		c100200170.stop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c100200170.tg(filter)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c100200170.op(filter)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c100200170.mmfilter(c)
	return c:IsSetCard(0x231) and c:IsAbleToHand()
end
c100200170.mmtg=c100200170.tg(c100200170.mmfilter)
c100200170.mmop=c100200170.op(c100200170.mmfilter)
function c100200170.l4filter(c)
	return c:IsLevel(4) and c:IsAbleToHand()
end
c100200170.l4tg=c100200170.tg(c100200170.l4filter)
c100200170.l4op=c100200170.op(c100200170.l4filter)
function c100200170.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
c100200170.sttg=c100200170.tg(c100200170.stfilter)
c100200170.stop=c100200170.op(c100200170.stfilter)
function c100200170.spfilter(c,e,tp)
	return c:IsSetCard(0x231) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100200170.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,false,nil,nil)
	Duel.Release(sg,REASON_COST)
end
function c100200170.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100200170.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100200170.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100200170.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
