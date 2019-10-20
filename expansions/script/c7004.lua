--tSG‐生来の門
function c7004.initial_effect(c)
	c:EnableCounterPermit(0x80)
	c:SetCounterLimit(0x80,99)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c7004.condition)
	e3:SetOperation(c7004.acop)
	c:RegisterEffect(e3)
end
function c7004.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:GetPreviousControler()==tp
end
function c7004.cfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLevel(lv)
end
function c7004.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c7004.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x80,lv,true)
	end
end