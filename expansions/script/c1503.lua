--デバッグ－システム追加
function c1503.initial_effect(c)
	-- 相手フィールドにフィールド魔法を創造する
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,1503+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xf7)
	e1:SetOperation(c1503.op)
	c:RegisterEffect(e1)
	--カードを創造する
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_PREDRAW)
	ge1:SetOperation(c1503.sdop)
	ge1:SetCountLimit(1,1503)
	ge1:SetCondition(c1503.sdcon)
	Duel.RegisterEffect(ge1,0)
	-- 相手に希望を与える
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_PREDRAW)
	ge2:SetRange(LOCATION_GRAVE)
	ge2:SetOperation(c1503.sdop2)
	ge2:SetCountLimit(1,1503)
	Duel.RegisterEffect(ge2,0)
end
function c1503.sdop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	Duel.Remove(e:GetHandler(),LOCATION_GRAVE,POS_FACEUP)
	local c=e:GetHandler():GetOwner()
	if Duel.SelectYesNo(c,aux.Stringid(1503,2)) then
	local tc=Duel.AnnounceCard(c)
	Duel.SetTargetParam(tc)
	local token=Duel.CreateToken(1-c,tc,2,nil,nil,nil,nil,nil)
	if token then
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	end
	end
end
function c1503.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	Duel.Remove(e:GetHandler(),LOCATION_GRAVE,POS_FACEUP)
	local c=e:GetHandler():GetOwner()
	if Duel.SelectYesNo(c,aux.Stringid(1503,0)) then
	local tc=Duel.AnnounceCard(c)
	Duel.SetTargetParam(tc)
	local token=Duel.CreateToken(c,tc,nil,nil,nil,nil,nil,nil)
	if token then
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	end
	end
end
function c1503.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=1
end
function c1503.op(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler():GetOwner()
	Duel.Remove(e:GetHandler(),LOCATION_GRAVE,POS_FACEUP)
	if Duel.SelectYesNo(c,aux.Stringid(1503,1)) then
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if tc==nil then
		-- Duel.SendtoDeck(e:GetHandler(),tp,tp,REASON_RULE,POS_FACEUP,true)
		if tc2==nil then
			c1503.announce_filter={TYPE_FIELD,OPCODE_ISTYPE}
			local code=Duel.AnnounceCardFilter(tp,table.unpack(c1503.announce_filter))
			local token=Duel.CreateToken(tp,code,nil,nil,nil,nil,nil,nil)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SSET)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(nil,1)
			e2:SetTarget(c1503.setlimit)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(nil,1)
			e3:SetValue(c1503.actlimit)
			Duel.RegisterEffect(e3,tp)
			--indestructable
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetTargetRange(nil,LOCATION_FZONE)
			e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e4:SetValue(1)
			Duel.RegisterEffect(e4,tp)
			--indestructable
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e5:SetTargetRange(nil,LOCATION_FZONE)
			e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e5:SetValue(1)
			Duel.RegisterEffect(e5,tp)
		end
	else
		Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_EFFECT)
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
end
function c1503.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c1503.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
