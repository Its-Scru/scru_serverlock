webhookurl = 'https://discord.com/api/webhooks/993148459869806592/Dznrd2lhqmGl49yaaS1CHCRD4KtRsSyPmDO-KF9_DTvAK2Qmy0VVkXmsSg8DM0h7Qewe' -- Add your discord webhook url here, if you do not want this leave it blank (More info on FiveM post) --

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
    if config.DiscordAndPassword then
    local capital_letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
    local low_letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
    local numbers = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
  
    math.randomseed(os.time())
  
    local length = 10
    local pass = ""
    local choice = 0
  
    for _ = 1, length do
      choice = math.random(3)
  
      -- Capital letters
      if choice == 1 then
        pass = pass .. capital_letters[math.random(#capital_letters)]
      -- Low letters
      elseif choice == 2 then
        pass = pass .. low_letters[math.random(#low_letters)]
      -- Numbers
      else
        pass = pass .. numbers[math.random(#numbers)]
      end
    end

    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = FF0000,
            ["title"] = 'Password',
            ["description"] =  'Password: '..pass.. '\nPlayer Connecting: ' ..name.. "",
            ["footer"] ={
            ["text"] = timestamp.." (Server Time).",
            },
        }
    }
    PerformHttpRequest(config.DiscordWebhook,
    function(err, text, headers)end, 'POST', json.encode({username = 'SCRU SERVERLOCK', avatar_url= '' ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
    local show = true
    while show do
        Wait(0)
        deferrals.presentCard(passcodeCard, function (data, rawdata)

            if data.passcode == pass then 
                show = false
                deferrals.done()
                print(("%s entered the correct password!"):format(name))
            else
                deferrals.done(config.failMessage)
               print(("%s tried to connect to the server with the wrong password!"):format(name))
            end
        end)
    end
    else
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
end
end)

