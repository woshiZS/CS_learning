-- local gridId2Players = {}
-- local gridIdList = {1, 2, 1, 1, 2, 3, 4, 6, 6, 6}
-- local playerId = {213212421, 1231421512, 514124124, 1313124, 4142132, 131242134, 1312412, 313144532, 1232145, 3247373}

-- for i = 1, 10, 1 do
--     if gridId2Players[gridIdList[i]] == nil then
--         gridId2Players[gridIdList[i]] = {}
--     end
--     table.insert(gridId2Players[gridIdList[i]], playerId[i])
-- end

-- -- 不知道可以不可以print table
-- for gridId, players in pairs(gridId2Players) do
--     for _, playerId in pairs(players) do
--         print(gridId, playerId)
--     end
-- end
-- local testTable = {}
-- local gridId = 79
-- local offlineInfo = {}
-- offlineInfo.leftTime = 40
-- offlineInfo.damageAcc = 132420
-- offlineInfo.combatPetList = {"123214214", "324124124", "234124124"}
-- local gbId = 328901829048
-- testTable[gridId] = {}
-- table.insert(testTable[gridId], {gbId, offlineInfo})

-- local gridIdInfos = testTable[gridId]
-- for _, infos in pairs(gridIdInfos) do
--     print(infos[1])
--     for key, value in pairs(infos[2]) do
--         print(key, value)
--     end
-- end

-- local offlineInfo = {}
-- offlineInfo.gridId = 70
-- offlineInfo.leftTime = 80
-- for key, value in pairs(offlineInfo) do
--     print(key, value)
-- end

local offlineList = {}
-- offlineList[70] = {}
-- table.insert(offlineList[70], 134789187348917)
-- table.insert(offlineList[70], 13478918000000)
-- for _, items in pairs(offlineList) do
--     for _, playerId in pairs(items) do
--         print(playerId)
--     end
-- end

-- table.remove(offlineList[70], 134789187348917)
-- for _, items in pairs(offlineList) do
--     for _, playerId in pairs(items) do
--         print(playerId)
--     end
-- end
offlineList.hello = 5
print(offlineList["hello"])