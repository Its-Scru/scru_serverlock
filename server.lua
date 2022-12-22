AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local player = source
    deferrals.defer()
    Wait(0) 

    local passcodeCard = {
        ["type"] = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.5",
        ["body"] = {
            {
                ["type"] = "TextBlock",
                ["text"] = config.message,
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
    while show do
        Wait(0)
        deferrals.presentCard(passcodeCard, function (data, rawdata)
            if data.passcode == config.password then 
                show = false
                deferrals.done()
                print(("%s entered the correct password!"):format(name))
            else
                deferrals.done(config.failMessage)
                print(("%s tried to connect to the server with the wrong password!"):format(name))
            end
        end)
    end
end)
