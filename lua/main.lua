-- Instant Shield Cleanup: retain only the original shield disposal behavior.
if RequiredScript ~= "lib/managers/enemymanager" then
    return
end

local SHIELD_CHECK_INTERVAL = 0.10

local function should_keep_shields()
    if not managers.groupai then
        return false
    end

    local state = managers.groupai:state()
    return state and state:whisper_mode()
end

Hooks:PostHook(EnemyManager, "init", "ICC_NativeShieldDisposalSetup", function(self)
    self._MAX_NR_SHIELDS = 0
    self._shield_disposal_lifetime = 0
    self._shield_disposal_upd_interval = SHIELD_CHECK_INTERVAL
end)

Hooks:PostHook(EnemyManager, "shield_limit", "ICC_ForceZeroShieldLimit", function()
    if should_keep_shields() then
        return 9999
    end

    return 0
end)

-- Let the native disposal pass remove shields after registration is complete.
