-- Mass invite lua, ported by KillaBoi, credits to Aviarita, fuck Onyx

panorama.RunScript([[
    let collectedSteamIDS = [];
    collectedSteamIDS.push("123");
]])


local Reference = gui.Reference("Misc", "Enhancement")
local InviteGroupbox = gui.Groupbox( Reference, "Mass Invite", 330, 315, 295 ) 

local refresh = false
local function refresh_nearbies()
    panorama.RunScript([[
        PartyBrowserAPI.Refresh();
        var lobbies = PartyBrowserAPI.GetResultsCount();
        for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
            var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
            if (!collectedSteamIDS.includes(xuid)) {
                if (collectedSteamIDS.includes('123')) {
                    collectedSteamIDS.splice(collectedSteamIDS.indexOf('123'), 1);
                }
                collectedSteamIDS.push(xuid);
                $.Msg(`Adding ${xuid} to the collection..`);
            }
        }
        $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);
    ]]) 
end
refresh_nearbies()



local ezRefresh = gui.Checkbox( InviteGroupbox, "AutoRefresh", "Auto Refresh Nearby", false)

local shittyDelay = 0

local function autoSpamInvite()
    if ezRefresh:GetValue() then
        if shittyDelay == 1000 then 
            refresh_nearbies()
            shittyDelay = 0
        else
            shittyDelay = shittyDelay + 1 
        end 
    end
end



gui.Button(InviteGroupbox, "Refresh Nearby Players", function()
    panorama.RunScript([[
        PartyBrowserAPI.Refresh();
        var lobbies = PartyBrowserAPI.GetResultsCount();
        for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
            var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
            if (!collectedSteamIDS.includes(xuid)) {
                if (collectedSteamIDS.includes('123')) {
                    collectedSteamIDS.splice(collectedSteamIDS.indexOf('123'), 1);
                }
                collectedSteamIDS.push(xuid);
                $.Msg(`Adding ${xuid} to the collection..`);
            }
        }
        $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);
    ]]) 
end)

gui.Button(InviteGroupbox, "Mass Invite Nearby", function()
    panorama.RunScript([[
        collectedSteamIDS.forEach(xuid => {
            FriendsListAPI.ActionInviteFriend(xuid, "");
        });
    ]])
end)

gui.Button(InviteGroupbox, "Print Saved SteamID64", function()
    panorama.RunScript([[
        $.Msg('')
        $.Msg('-------------------- SteamID64 List --------------------')
        $.Msg('  This list contains all nearby players that were saved')
        $.Msg('')
        $.Msg(collectedSteamIDS);
        $.Msg('')
    ]])
end)

gui.Button(InviteGroupbox, "Invite All Friends", function()
    panorama.RunScript([[
        var friends = FriendsListAPI.GetCount();
        for (var id = 0; id < friends; id++) {
            var xuid = FriendsListAPI.GetXuidByIndex(id);
            FriendsListAPI.ActionInviteFriend(xuid, "");
        }
    ]]) 
end)

callbacks.Register("Draw", autoSpamInvite)
