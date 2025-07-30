-- 📦 Referências
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- 🖼️ ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "RapidFireGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- 🪟 Frame principal (arrastável)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- 🏷️ Título do Frame
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 RapidFire + NoCooldown"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- 🔘 Botão de Ativar/Desativar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 170, 255)
toggleButton.Text = "Ativar RapidFire"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = frame

-- ⚙️ Remove cooldown verificando múltiplos nomes
local function removeCooldown(env)
    pcall(function()
        local vars = {
            "cooldown", "coolDown", "cd", "fireDelay", "fireCooldown", "reloadTime", "reloadCooldown", "reloading",
            "isReloading", "isCoolingDown", "canShoot", "canFire", "readyToFire", "delay", "delayTime",
            "fireRate", "nextShot", "nextFire", "lastShot", "lastFired", "nextFireTime", "lastFireTime",
            "reload", "reloadTimer", "shootingDelay", "waitTime", "waitBetweenShots", "fireWait", "weaponCooldown",
            "gunCooldown", "shootDelay", "canAttack", "attackReady", "attackCooldown", "fireCD", "cool",
            "cooling", "coolDownTimer", "hasCooldown", "cooldownTicks", "lastAttack", "nextAttack", "coolDownState",
            "reloadState", "reloadWait", "canReload", "needsReload", "burstCooldown", "burstDelay", "weaponWait",
            "shotCooldown", "attackDelay", "triggerDelay"
        }

        for _, varName in ipairs(vars) do
            local value = rawget(env, varName)
            if value ~= nil then
                if typeof(value) == "boolean" then
                    env[varName] = false
                elseif typeof(value) == "number" then
                    env[varName] = 0.01
                end
            end
        end
    end)
end

-- 🔫 Função para disparar
local enabled = false
local function fire()
    local char = player.Character
    local tool = char and char:FindFirstChild("Harpoon") or player.Backpack:FindFirstChild("Harpoon")
    if tool and tool:FindFirstChild("LocalScript") then
        local env = getsenv(tool.LocalScript)
        if env and env.fireWeapon then
            removeCooldown(env)
            pcall(function()
                if rawget(env, "var6_upvw") then
                    env.var6_upvw = 1
                end
                if rawget(env, "var9_upvw") then
                    env.var9_upvw = false
                end
                env.fireWeapon()
            end)
        end
    end
end

-- 🌀 Loop de disparo
RunService.RenderStepped:Connect(function()
    if enabled then
        fire()
    end
end)

-- 🖱️ Alternar botão
toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleButton.Text = enabled and "Desativar RapidFire" or "Ativar RapidFire"
    toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(50, 170, 255)
end)
