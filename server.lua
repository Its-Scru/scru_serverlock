function GetPlayerIdentifierFromType(type, player)
    local identifierCount = GetNumPlayerIdentifiers(player)
    for count = 0, identifierCount do
        local identifier = GetPlayerIdentifier(player, count)
        if identifier and string.find(identifier, type) then
            return identifier
        end
    end
    return nil
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local player = source
    local identifier = GetPlayerIdentifierFromType("license", player)
    deferrals.defer()
    Wait(0) 

    local passcodeCard = {
        ["type"] = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.5",
        ["body"] = {
            {
                ["type"] = "TextBlock",
                ["text"] = config.passwordMessage,
                ["wrap"] = true,
                ["style"] = "heading"
            },
            {
                ["type"] = "Input.Text",
                ["placeholder"] = "Password",
                ["id"] = "passcode",
                ["isRequired"] = true,
                ["errorMessage"] = "Required Field*",
                ["maxLength"] = 30,
                ["style"] = "Password"
            },
            {
                ["type"] = "ActionSet",
                ["actions"] = {
                    {
                        ["type"] = "Action.Submit",
                        ["title"] = "Submit",
                        ["style"] = "positive",
                        ["id"] = "submit"
                    }
                }
            }
        }
    }

    local show = true
    for _, whitelistLicense in pairs(config.whitelistedUsers) do
        if identifier == whitelistLicense then
            deferrals.done()
            print(("%s is whitelisted and entering the server."):format(name))
            return
        end
    end
    while show do
        Wait(0)
        deferrals.presentCard(passcodeCard, function (data, rawdata)
            if data.passcode == config.password then 
                show = false
                deferrals.done()
                print(("%s entered the correct password!"):format(name))
            else
                deferrals.done(config.passwordFailMessage)
                print(("%s tried to connect to the server with the wrong password!"):format(name))
            end
        end)
    end
end)
