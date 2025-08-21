--Find Basalt File for UI--
local basalt = require("basalt")
--Find monitor -- -- Check Monitor Name--
local monitor = peripheral.wrap("monitor_0")
--monitor Size--
local w, h = monitor.getSize()
--Find Chest--
local chest = peripheral.wrap("minecraft:ironchest_diamond_1")

--GetTotaltems--
local function getTotalItems()
  local totalCount = 0
  for _, item in pairs(chest.list()) do
    totalCount = totalCount + item.count
  end
  return totalCount
end

--GetItemsPerMinute--
local function getItemsPerMinute()
  local startTime = os.time()
  local itemsAtStart = getTotalItems()
  sleep(60) 
  local itemsNow = getTotalItems()
  return itemsNow - itemsAtStart
end

--Get StorageSize--
local function getMaxStorage()
  return chest.size()*64
end

--GetStoragePercentage--
local function getStoragePercentage()
  local current = getTotalItems()
  local max = getMaxStorage()
  return math.floor((current / max)*100)
end

--Monitor UI--
--Monitor Backgound--
local monitorFrame = basalt.createFrame()
  :setTerm(monitor)
  :setBackground(colors.black) --color of background

--Main Body Background + Text--
-- Add title textbox
monitorFrame:addTextBox()
    :setText(" Graphs")
    :setPosition(w - 41, h - 24) -- Adjust based on monitor size
    :setSize(w - 53, h - 25)
    :setBackground(colors.black)
    :setForeground(colors.blue)

-- Draw outer blue background rectangle
monitorFrame:getCanvas()
    :rect(2, 2, w - 26, h - 2, " ", colors.blue, colors.blue)
-- Draw inner black content rectangle
monitorFrame:getCanvas()
    :rect(3, 3, w - 28, h - 4, " ", colors.black, colors.black)

--Add Title Text Box--
monitorFrame:addTextBox()
    :setText(" Storage")
    :setPosition(w - 11, h - 24)  -- Centers "Storage" text near the top
    :setSize(w - 52, h - 25)
    :setBackground(colors.black)
    :setForeground(colors.yellow)

-- Draw outer yellow background box
monitorFrame:getCanvas()
    :rect(38, 2, w - 40, h - 16, " ", colors.yellow, colors.yellow)
-- Draw inner black box (content area)
monitorFrame:getCanvas()
    :rect(39, 3, w - 40, h - 18, " ", colors.black, colors.black)

local itemLabel = monitorFrame:addLabel()
    :setText("LV Panels: 0 ")
    :setPosition(w - 21, 4)
    :setForeground(colors.white)

--==Item Total Function==--
local function updateTotal()
    while true do
        local count = getTotalItems()
        itemLabel:setText("LV Panels: " .. count)
        sleep(1)
    end
end

local rateLabel = monitorFrame:addLabel()
    :setText("Per Minute: ... ")
    :setPosition(w - 21, 6)
    :setForeground(colors.white)

--==Total per Min Function==--
local function updateRate()
    while true do
        local rate = getItemsPerMinute()
        rateLabel:setText("Per Minute: " .. rate)
    end
end

--==Storage Percentage Function==--
local function updateStoragePercentage()
  while true do 
    local percentage = getStoragePercentage()
    local barWidth = w - 42
    local scaledWidth = math.floor((percentage / 100) * barWidth)

    monitorFrame:GetCanvas()
    :rect(40, 8, barWidth, 1 , " ",colors.gray,colors.gray)
    monitorFrame:GetCanvas()
    :rect(40, 8, scaledWidth, 1 , " ",colors.green,colors.green)
  end
end

--==UpdateLoop==--
parallel.waitForAll(
  function() basalt.run() end,
  updateTotal,
  updateRate,
  updatePercentag
)
    
    
