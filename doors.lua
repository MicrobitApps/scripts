local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "P6auls Doors Hub",
    Icon = "skull", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Never use my scripts without credit!",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "doorshub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "P6auls Doors Hub",
       Subtitle = "Key Verification",
       Note = "In Beta. If you want, here is a key: 67890", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"p6aulsadmin","345345","12345", "67890", "23456", "98765", "34567", "45678", "56789", "87654", "54321", "65432", "76543", "43210", "21098", "10987", "32109", "89012", "67812", "45123", "85236", "96325", "74152", "85214", "95173", "75314", "12435", "65789", "78963", "96314", "35714", "25814", "35914", "74163", "25893", "14725", "36982", "58462", "91435", "63582", "52684", "18395", "29486", "57813", "96732", "31685", "92463", "17538", "38652", "51924", "84639", "13574", "39285", "67421"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local function create_notification(title, content, duration, image)
    Rayfield:Notify({
        Title = title or "Success",
        Content = content or "Error",
        Duration = duration or 3,
        Image = image or "badge-plus",
    })
end


 Rayfield:Notify({
    Title = "Welcome",
    Content = "This script is still in Beta!",
    Duration = 6.5,
    Image = "badge-alert",
 })

 local MainTab = Window:CreateTab("Script Hub", "archive") -- Title, Image

 local ExploitsSection = MainTab:CreateSection("Exploits")

 local headlight = false
 local headlightBrightness = 2
 local headlightRange = 16

 local BlackKingLaunchButton = MainTab:CreateButton({
    Name = "Bobhub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DarkDoorsKing/Doors/main/Main"))()
    end,
 })

 local msdoorsLaunchButton = MainTab:CreateButton({
    Name = "Ms Doors (Outdated)",
    Callback = function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/mstudio45/MSDOORS/main/MSDOORS.lua"),true))()
    end,
 })

 local neverlooseLaunchButton = MainTab:CreateButton({
    Name = "NeverLoose.xyz (Outdated)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaQLeak/neverlose.xyz/main/Doors.lua"))()
    end,
 })

 local VYNIXIUSLaunchButton = MainTab:CreateButton({
    Name = "VYNIXIUS Doors",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Doors/Script.lua"))()
    end,
 })

 local espObjects = {}

-- Define colors for each model type
local modelColors = {
    KeyObtain = Color3.fromRGB(255, 0, 0), -- Red
    LiveHintBook = Color3.fromRGB(0, 255, 0), -- Green
    Wardrobe = Color3.fromRGB(0, 0, 255), -- Blue
    Door = Color3.fromRGB(255, 255, 0), -- Yellow
    Dresser = Color3.fromRGB(255, 165, 0), -- Orange
}

-- Function to create an ESP highlight with label
local function create_esp(object, modelName)
    if not object:IsA("BasePart") then return end

    -- Highlight box
    local adornment = Instance.new("BoxHandleAdornment")
    adornment.Name = "ESPAdornment"
    adornment.Adornee = object
    adornment.AlwaysOnTop = true
    adornment.ZIndex = 10
    adornment.Size = object.Size + Vector3.new(0.1, 0.1, 0.1) -- Slightly larger than the object
    adornment.Color3 = modelColors[modelName] or Color3.new(1, 1, 1) -- Default to white if no color is defined
    adornment.Transparency = 0.5
    adornment.Parent = object

    -- Label
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Adornee = object
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0) -- Position above the object
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = modelName
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = modelColors[modelName] or Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    billboard.Parent = object

    -- Track the object
    espObjects[object] = {adornment, billboard}
end

-- Function to remove all ESP highlights and labels
local function remove_esp()
    for object, components in pairs(espObjects) do
        for _, component in ipairs(components) do
            if component and component.Parent then
                component:Destroy()
            end
        end
    end
    espObjects = {}
end

-- Function to check recursively and apply ESP
local function check_and_highlight(object)
    if object:IsA("Model") then
        -- Handle KeyObtain
        if object.Name == "KeyObtain" then
            local hitbox = object:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then
                local key = hitbox:FindFirstChild("Key")
                if key and key:IsA("BasePart") and not espObjects[key] then
                    create_esp(key, "KeyObtain")
                end
            end
        -- Handle other models
        elseif modelColors[object.Name] then
            local part = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
            if part and not espObjects[part] then
                create_esp(part, object.Name)
            end
        end
    end

    -- Recursively check children
    for _, child in ipairs(object:GetChildren()) do
        check_and_highlight(child)
    end
end

-- Function to toggle ESP on
local function toggle_esp_on()
    check_and_highlight(workspace)
end


 local function create_head_light(player)
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head

        if head:FindFirstChild("HeadLight") then
            warn("Head light already exists!")
            return
        end

        local light = Instance.new("PointLight")
        light.Name = "HeadLight"
        light.Parent = head
        light.Range = headlightRange -- Adjust the range of the light
        light.Brightness = headlightBrightness -- Adjust the brightness of the light
        light.Color = Color3.new(1, 1, 1) -- White light
        print("Head light created!")
    else
    end
end

local function delete_head_light(player)
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head

        local light = head:FindFirstChild("HeadLight")
        if light then
            light:Destroy()
        else
        end
    else
        warn("Player does not have a valid character or head.")
    end
end

 local ExploitTab = Window:CreateTab("Instant Exploit", "badge-plus") -- Title, Image

 local SettingsTab = Window:CreateTab("Settings", "lock-open") -- Title, Image

 local shownotificationsforsuccess = true
 local entitynotify = false
 local thirdPerson = false
 local notifiedthirdPerson = 0
 local Esp = false

 local shownotificationsforsuccessToggle = SettingsTab:CreateToggle({
    Name = "Show success messages",
    CurrentValue = true,
    Flag = "shownotificationsforsuccessToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
   shownotificationsforsuccess = Value
    end,
 })



 local knobstogive = 0

 local Slider = ExploitTab:CreateSlider({
    Name = "Amount of Gold",
    Range = {0, 10000},
    Increment = 100,
    Suffix = "Gold",
    CurrentValue = 100,
    Flag = "knobsajustwithbutton", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
   knobstogive = Value
    end,
 })

 local GiveKnobsButton = ExploitTab:CreateButton({
    Name = "Give Gold!",
    Callback = function()
   game.Players.LocalPlayer.Gold.Value += knobstogive
   if shownotificationsforsuccess == true then
   create_notification("Success", "We gave you your gold!", 3, "badge-alert")
   end
    end,
 })

 local Divider = ExploitTab:CreateDivider()

 local rushNotifyToggle = ExploitTab:CreateToggle({
    Name = "Entity Notifier",
    CurrentValue = false,
    Flag = "shownotificationsforsuccessToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
   entitynotify = Value
    end,
 })

 local thirdPersonToggle = ExploitTab:CreateToggle({
    Name = "Third Person Mode",
    CurrentValue = false,
    Flag = "thirdPersonToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
   thirdPerson = Value
    end,
 })

 local EspToggle = ExploitTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "EspToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Esp = Value
    end,
 })

 local Divider1 = ExploitTab:CreateDivider()

 local headLightPowerSlider = ExploitTab:CreateSlider({
    Name = "HeadLight Power",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 16,
    Flag = "headLightPowerSlider", 
    Callback = function(Value)
    headLightPowerSlider = Value
    delete_head_light(game.Players.LocalPlayer)
    create_head_light(game.Players.LocalPlayer)
    end,
 })

 local headLightRangeSlider = ExploitTab:CreateSlider({
    Name = "HeadLight Range",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Range",
    CurrentValue = 16,
    Flag = "headLightRangeSlider", 
    Callback = function(Value)
    headlightRange = Value
    delete_head_light(game.Players.LocalPlayer)
    create_head_light(game.Players.LocalPlayer)
    end,
 })

 local headLightToggle = ExploitTab:CreateToggle({
    Name = "Headlight",
    CurrentValue = false,
    Flag = "headLightToggle", 
    Callback = function(Value)
    if headlight == false then
        delete_head_light(game.Players.LocalPlayer)
    else
        create_head_light(game.Players.LocalPlayer)
    end
    end,
 })








 local notifiedModels = {}

 function check_for_rush_moving()
    local modelsFound = false
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "RushMoving" and not notifiedModels[obj] then
            -- Trigger notification
            create_notification("Entity!", "Rush has spawned! Hide quickly!", 5, "alert-circle")
            print("rush")
            -- Mark this model as notified
            notifiedModels[obj] = true
            modelsFound = true
        end
    end
    -- Optional: Log a message if no models are found
    if not modelsFound then
       
    end
end

function check_for_ambush_moving()
    local modelsFound = false
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "AmbushMoving" and not notifiedModels[obj] then
            -- Trigger notification
            create_notification("Entity!", "Ambush has spawned! Hide quickly!", 5, "alert-circle")
            print("ambush")
            notifiedModels[obj] = true
            modelsFound = true
        end
    end
    -- Optional: Log a message if no models are found
    if not modelsFound then
       
    end
end

function check_for_seek_moving()
    local modelsFound = false
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "SeekMovingNewClone" and not notifiedModels[obj] then
            -- Trigger notification
            create_notification("Entity!", "Seek has spawned! Run quickly!", 5, "alert-circle")
            print("seek")
            -- Mark this model as notified
            notifiedModels[obj] = true
            modelsFound = true
        end
    end
    -- Optional: Log a message if no models are found
    if not modelsFound then
       
    end
end

while true do
    if entitynotify == true then
    check_for_rush_moving()
    check_for_seek_moving()
    check_for_ambush_moving()
    end
    if thirdPerson == true then
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
        if shownotificationsforsuccess == true and notifiedthirdPerson == 0 then
            notifiedthirdPerson = 1
            create_notification("Success", "You are now in Third Person. If not, try to toggle again!", 3, "badge-alert")
        end
    else
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        if shownotificationsforsuccess == true and notifiedthirdPerson ==  1 then
            notifiedthirdPerson = 0
            create_notification("Success", "You are now in First Person. If not, try to toggle again!", 3, "badge-alert")
        end
    end
    if Esp == true then
        toggle_esp_on()
    else
        remove_esp()
    end
    task.wait(0.2)
end
