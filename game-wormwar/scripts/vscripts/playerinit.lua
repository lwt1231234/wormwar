function init_player_stats()
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0', '')
	math.randomseed(tonumber(timeTxt))

	Player_Stats={}
	for i=0,9 do
		Player_Stats[i]={}	--每个玩家的数据包
		Player_Stats[i]['length']=0;
	end

	--获取刷怪区域坐标
	local temp_entity = Entities:FindByName(nil,"left_up")
	left_up_xyz	= temp_entity:GetAbsOrigin()
	local temp_entity = Entities:FindByName(nil,"right_down")
	right_down_xyz = temp_entity:GetAbsOrigin()

	--刷新基础的
	for i=1,5 do
		createunit("sheep")
	end
	for i=1,3 do
		createunit("cow")
	end
	for i=1,1 do
		createunit("fireman")
	end
end


function createunit(unitname)
	local location=Vector(math.random(right_down_xyz.x - left_up_xyz.x) + left_up_xyz.x,
						  math.random(right_down_xyz.y - left_up_xyz.y) + left_up_xyz.y,
						  right_down_xyz.z)

	local unit=CreateUnitByName(unitname, location, true, nil, nil, DOTA_TEAM_NEUTRALS)

	unit:SetContext("name", unitname, 0)
end