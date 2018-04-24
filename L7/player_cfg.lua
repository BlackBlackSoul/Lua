--
-- Created by CLion.
-- User: Tooster   Date: 24.04.2018   Time: 15:53
--



name = "Archibald"
race = "human"

if(LVL == nil or LVL < 40) then class = "wizard"
elseif (LVL < 50) then class = "arch wizard"
else class = "elder mage" end

born = "Sheer village"
height = 1.78

if(class == "wizard") then sarcasmFactor = 0.12
elseif(class == "arch wizard") then sarcasmFactor = 0.34
else sarcasmFactor = 0.57 end

age = 34
eyes = "green"
hair = "black"
hat = true
langHumans = true
langElves = false
langBeasts = true
staffName = "Chunchunmaru"
