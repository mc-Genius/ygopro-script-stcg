--Ai打ち
--TA.I. Strike
--Scripted by Eerie Code, anime version by Larry126
function c101011051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,101011051+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101011051.condition)
	e1:SetOperation(c101011051.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101011051.reptg)
	e2:SetValue(c101011051.repval)
	e2:SetOperation(c101011051.repop)
	c:RegisterEffect(e2)
end
c101011051.listed_series={0x234}
function c101011051.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	local tc=Duel.GetAttacker()
	if not tc:IsControler(tp) then tc,bc=bc,tc end
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and not bc:IsControler(tp)
end
function c101011051.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e)
		and tc:IsControler(tp) and not bc:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(bc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EVENT_DAMAGE_STEP_END)
		e2:SetOperation(c101011051.damop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101011051.damage(c)
	if c:GetReason()&0x21==0x21 then 
		Duel.Damage(c:GetPreviousControler(),c:GetBaseAttack(),REASON_EFFECT)
	end
end
function c101011051.damop(e,tp,eg,ep,ev,re,r,rp)
	c101011051.damage(Duel.GetAttacker())
	c101011051.damage(Duel.GetAttackTarget())
end
function c101011051.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x234) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_BATTLE)
end
function c101011051.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c101011051.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101011051.repval(e,c)
	return c101011051.repfilter(c,e:GetHandlerPlayer())
end
function c101011051.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
