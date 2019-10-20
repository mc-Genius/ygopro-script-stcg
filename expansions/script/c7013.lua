--クリボタン
function c7013.initial_effect(c)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7013.condition)
	e1:SetCost(c7013.cost)
	e1:SetTarget(c7013.target)
	e1:SetOperation(c7013.operation)
	c:RegisterEffect(e1)

end
function c7013.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c7013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c7013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local at=Duel.GetAttacker()
		return at:IsAttackPos() and at:IsCanChangePosition()
	end
end
function c7013.operation(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at:IsAttackPos() and at:IsRelateToBattle() then
		Duel.ChangePosition(at,POS_FACEUP_DEFENSE)
	end
end