M = {}
M.npc = function (posX , posY)
    local bot = display.newGroup()
    local options =
    {
        width = 24,
        height = 20,
        numFrames = 10
    }
    local sheet = graphics.newImageSheet( "img/bot.png", options )
    local sequenceData =
    {
        {name="idle",
        frames= { 1, 2, 3}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="walking",
        frames= { 4, 5, 6, 5}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="hit",
        frames= { 9 , 8 , 7}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="died",
        frames= { 10}, -- frame indexes of animation, in image sheet
        time = 1000}
    }
    bot.x = posX
    bot.y = posY
    bot.hp = 100
    bot.class = 'enemy'
    bot.sequence = 'idle'
    local npc = display.newSprite( bot ,sheet, sequenceData )
    npc:setSequence( 'idle' )
    npc:play()

    npc.botControler = function(event)
        if event.phase and npc.sequence == 'hit' and event.target.frame == event.target.numFrames then
            local axisEvent
            axisEvent = {name = "bot", target = bot, phase = 'attack' }
            Runtime:dispatchEvent(axisEvent)
        end
    end

    npc:addEventListener( "sprite", npc.botControler )
    local npcHp = display.newRect( bot,-4,-12,12,1 )
    npcHp.alpha = 0.7
    function bot:setSequence(sequence)
        bot.sequence = sequence
        npc:setSequence( sequence )
        npc:play()
    end

    function bot:addHp(HP)
        bot.hp = bot.hp + HP
        npcHp.width = bot.hp / 10
        npcHp.x = npcHp.x + HP / 20
        if bot.hp <= 0 then
            npcHp.width = 0
            bot.isDead = true
            npc:setSequence('died')
            npc:play()
        end
    end
    bot.isDead = false
    bot.state = "idle"
    bot.speed = 0.2
    return bot
end

M.player = function (posX , posY)
    local options =
    {
        width = 26,
        height = 36,
        numFrames = 96,
        sheetContentWidth = 312,  -- width of original 1x size of entire sheet
        sheetContentHeight = 288 
    }
    local sheet = graphics.newImageSheet( "img/player.png", options )
    local sequenceData =
    {
        {name="idle_down",
        frames= { 7, 8, 9}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="idle_left",
        frames= { 19, 20, 21}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="idle_right",
        frames= { 31, 32, 33}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="idle_up",
        frames= { 43, 44, 45}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="run_down",
        frames= {1,2,3,4,5,6}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="run_left",
        frames= {13,14,15,16,17,18}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="run_right",
        frames= {25,26,27,28,29,30}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="run_up",
        frames= {37,38,39,40,41,42}, -- frame indexes of animation, in image sheet
        time = 1000},

        {name="hit",
        frames= {50,62}, -- frame indexes of animation, in image sheet
        time = 400},

        {name="died",
        frames= {53,65}, -- frame indexes of animation, in image sheet
        time = 400}


    }
    local player = display.newGroup()
    local body = display.newSprite( player, sheet, sequenceData )

    player.x = posX
    player.y = posY
    player.hp = 1000
    player.isDead = false
    player.hpBar = display.newRect(100,10,player.hp/10,3)
    player.class = 'player'
    player.state = "idle"
    player.direction = "_down"
    player.weapon = {
        name = 'empty' ,
        type = 'melee',
        delay = 1000
    }

    function player:addHp(HP)
        player.hp = player.hp + HP
        player.hpBar.width = player.hp / 10
        player.hpBar.x = player.hpBar.x + HP / 20
        if player.hp <= 0 then
            player.hpBar.width = 0
            player.isDead = true
            player:setSequence('died')
        end
    end


    function player:setSequence(sequence)
        player.sequence = sequence
        body:setSequence( sequence )
        body:play()
    end

    player.angle = math.pi / 2
    player.speed = 1.2
    return player
end


return M