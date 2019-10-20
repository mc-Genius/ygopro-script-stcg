--Battle Pack：Epic Dawn
function c112900000.initial_effect(c)
	if not c112900000.global_check then
		c112900000.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetCountLimit(1)
		ge1:SetOperation(c112900000.op)
		Duel.RegisterEffect(ge1,0)
	end
end
pack1={78010363,34124316,77585513,79575620,89111398,61370518,40737112,25551951,4929256,88753985,
	83104731,12538374,85520851,44330098,73125233,79473793,17559367,9748752,59575539,98777036,
	10000000,5556499,10802915,84013237,10002346,47506081,69610924,68597372,31386180,94119480,
	71594310,12580477,72302403,55144522,18144506,79571449,4031928,19613556,45986603,70828912,
	68005187,73915051,56747793,31036355,44947065,98645731,41420027,44095762,97077563,83555666,
	53582587,26905245,82732705,49010598,77538567}
pack2={61831093,93920745,1347977,74131780,45141844,71413901,48343627,21502796,91133740,66788016,
	79759861,40619825,5318639,64047146,19230407,7165085,14087893,71453557,34236961,61127349,
	24874630,56460688,98045062,43040603,30683373,6178850,25789292,83584898,27243130,6430659,
	73178098,37390589,60082869,59744639,59344077,62279055,29267084,98239899,38411870,37576645,
	54704216,38275183,36261276,94192409,66518841,15552258,73729209,46502013,24673894,50078509,
	79161790,21636650,53656677,87106146,72022087,11091375}
pack3={49881766,79182538,13179332,35052053,69247929,78193831,78658564,40133511,88472456,78636495,
	53982768,49681811,18036057,2134346,63749102,53839837,42386471,83986578,40659562,46363422,
	51945556,70074904,51838385,14778250,90810762,16956455,70095154,59023523,85306040,78700060,
	77252217,85087012,93151201,20546916,39303359,61802346,78651105,51196174,37955049,60953118,
	83269557,17573739,70050374,44223284,23927545,59042331,12235475,95637655,41224658,7025445,
	4694209,94215860,62476815,51254277,12299841,12076263,33225925,41098335,53540729,13039848,
	28933734}
pack4={33508719,46657337,26302522,65240384,45894482,52860176,43586926,21593977,47025270,16268841,
	1434352,3510565,2671330,11448373,16226786,88975532,87621407,18325492,71218746,29216198,
	83982270,33695750,31034919,30312361,3657444,14089428,7736719,14506878,15658249,95360850,
	97021916,45620686,47217354,66288028,40225398,97385276,57421866,55099248,19665973,53162898,
	89567993,68473226,14785765,15394083,86952477,26082117,25259669}
pack5={}
for i,val in ipairs(pack1) do
	table.insert(pack5,val)
end
for i,val in ipairs(pack2) do
	table.insert(pack5,val)
end
for i,val in ipairs(pack3) do
	table.insert(pack5,val)
end
for i,val in ipairs(pack4) do
	table.insert(pack5,val)
end
function c112900000.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_HAND+LOCATION_DECK,0,1,nil,112900000)
		or not Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,0,LOCATION_HAND+LOCATION_DECK,1,nil,112900000)
		or Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK,1,nil,112900001,112900002,112900003) then
		Duel.Win(PLAYER_NONE,0x16)
		return
	end
	local g=Duel.GetFieldGroup(0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	local d0,d1,d2,d3,d4=Duel.TossDice(0,5)
	local d5,d6,d7,d8,d9=Duel.TossDice(1,5)
	local seed0=bit.lshift(d0,1)*bit.lshift(d1,2)*bit.lshift(d2,3)*bit.lshift(d3,4)*bit.lshift(d4,5)
	local seed1=bit.lshift(d5,5)*bit.lshift(d6,4)*bit.lshift(d7,3)*bit.lshift(d8,2)*bit.lshift(d9,1)
	if seed0==seed1 then seed1=seed1*bit.lshift(d5,5) end
	math.randomseed(seed0)
	local deck0,deck1=Group.CreateGroup(),Group.CreateGroup()
	local c1,c2,c3,c4,c5
	for i=1,10 do
		c1=Duel.CreateToken(0,pack1[math.random(#pack1)])
		c2=Duel.CreateToken(0,pack2[math.random(#pack2)])
		c3=Duel.CreateToken(0,pack3[math.random(#pack3)])
		c4=Duel.CreateToken(0,pack4[math.random(#pack4)])
		c5=Duel.CreateToken(0,pack5[math.random(#pack5)])
		deck0:AddCard(c1)
		deck0:AddCard(c2)
		deck0:AddCard(c3)
		deck0:AddCard(c4)
		deck0:AddCard(c5)
	end
	math.randomseed(seed1)
	for i=1,10 do
		c1=Duel.CreateToken(1,pack1[math.random(#pack1)])
		c2=Duel.CreateToken(1,pack2[math.random(#pack2)])
		c3=Duel.CreateToken(1,pack3[math.random(#pack3)])
		c4=Duel.CreateToken(1,pack4[math.random(#pack4)])
		c5=Duel.CreateToken(1,pack5[math.random(#pack5)])
		deck1:AddCard(c1)
		deck1:AddCard(c2)
		deck1:AddCard(c3)
		deck1:AddCard(c4)
		deck1:AddCard(c5)
	end
	Duel.SendtoDeck(deck0,nil,1,REASON_RULE)
	Duel.SendtoDeck(deck1,nil,1,REASON_RULE)
	if Duel.SelectYesNo(0,aux.Stringid(112900000,0)) then
		local cg=Duel.GetFieldGroup(0,LOCATION_DECK,0)
		Duel.ConfirmCards(0,cg)
	end
	if Duel.SelectYesNo(1,aux.Stringid(112900000,0)) then
		local cg=Duel.GetFieldGroup(1,LOCATION_DECK,0)
		Duel.ConfirmCards(1,cg)
	end
	Duel.ShuffleDeck(0)
	Duel.ShuffleDeck(1)
	Duel.Draw(0,5,REASON_RULE)
	Duel.Draw(1,5,REASON_RULE)
end