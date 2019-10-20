--Ancient Gear Triple Bite Hound Dog
function c511001544.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c511001544.mfilter1,c511001544.mfilter2,1,63,true)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c511001544.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(2)
	c:RegisterEffect(e2)
end
function c511001544.mfilter1(c)
	return c:IsCode(511001539)
end
function c511001544.mfilter2(c)
	return c:IsCode(511001540) or c:IsCode(511001539) and c:IsCode(511001539)
end
c511001544.material_setcode=0x7
function c511001544.fil1(c,fc,sub1,sub2)
	return c:IsFusionCode(42878636) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961))
end
function c511001544.fil2(c,fc,sub1,sub2)
	return c:IsFusionCode(511001540) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961))
end
function c511001544.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c511001544.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c511001544.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
