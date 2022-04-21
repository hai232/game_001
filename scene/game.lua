local composer = require( "composer" )
local widget = require( "widget" )
local spawm = require( "game.npc" )
local gamedata = require( "game.gamedata" )
local game_menu = require('scene.game_menu')
local controler = require('game.function')
local bot = require('game.bot')
local playerControler = require('game.player')
local vjoy = require( "game.joy" )
local attackHandler = require( "game.attack" )
local weapon = require('game.weapon')
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local data = gamedata.loadData()

local joystick = vjoy.newStick()
joystick.x, joystick.y = display.screenOriginX + display.contentCenterX / 3, display.contentHeight - display.contentCenterY / 2 

local attack = vjoy.newSkill()
attack.x, attack.y = display.contentWidth *9/10 , display.contentHeight - display.contentCenterY / 2 

local btn_A = vjoy.newButton( 17 , '' , "btnA")
btn_A.x , btn_A.y = display.viewableContentWidth , display.contentHeight*4/10

local btn_B = vjoy.newButton( 17 , 'img/weapon/wand.png' , "btnB")
btn_B.x , btn_B.y = display.viewableContentWidth , display.contentHeight*2/10


local path = display.newLine(0,0,10,10)
gameView = display.newGroup()

path.isVisible = false
local gameInfo = display.newGroup()
local ground_image = {}
local ground_array = {}
local bullet = {}
local player
local npc = {}
local ally = {}

local function bulletExplode(obj)
    obj.explode()
    controler.DealDamage(obj,npc)
    controler.DealDamage(obj,ally)
end

local function bulletUpdate()
    local bullet_hit=controler.CollisionArr(bullet , ally)
    if bullet_hit then
        bulletExplode(bullet_hit)
    end

    local bullet_hit=controler.CollisionArr(bullet , npc)
    if bullet_hit then
        bulletExplode(bullet_hit)
    end
end


playerControler.attack = function(angle)
    local index = #bullet + 1 
    table.insert(bullet,attackHandler.attack(player , angle , tostring(index) ,player.weapon.name));
    gameView:insert(bullet[index])
    bulletUpdate()
end

local function key(event)
    if event.phase == 'down' then
        if(event.keyName == 'btnA') then
        weapon(player , 'empty')
        end
        if(event.keyName == 'btnB') then
        weapon(player , 'gun')
        end
    end
end

local function botControler(event)
    if(event.phase == 'attack') then
        local index = #bullet + 1 
        table.insert(bullet,attackHandler.attack(event.target , angle , tostring(index) ,player.weapon.name));
        gameView:insert(bullet[index])
    end
end

local function axis(event)
    if event.phase == 'moved' then
        angle = joystick.angle
        path.x = player.x
        path.y = player.y
        path.rotation= event.angle * 180 / math.pi - 45;
        path.isVisible = true
    end
    if event.phase == 'ended' then
        path.isVisible = false
        if(player.weapon.type == 'range') then
        playerControler.attack(event.angle)
        end
        if(player.weapon.type == 'melee') then
            if(joystick.angle == nil) then
                playerControler.attack(player.angle)

            end
            if(joystick.angle ~= nil) then
                playerControler.attack(joystick.angle)
            end
        end
    end
end


local function playerFrame(event)
    if event.target.sequence == 'hit' and event.phase == 'loop' then
        playerControler.attack()
        player.state = 'idle'
        player:pause()
    end
end

local function botFrame( event )
    bot.eachFrame(event , player)
end

player = spawm.player(display.contentCenterX , display.contentCenterY)
player:addEventListener( "sprite", playerFrame )
table.insert(ally , player)
player.x = data.player.x or 0
player.y = data.player.y or 0
gameInfo:insert(player.hpBar)

game_menu.btn_main = function()
    
end

-- create()
function scene:create( event )
    local params = event.params
    -- Code here runs when the scene is first created but has not yet appeared on screen
    game_menu.isVisible = true
-- Create the widget
    sceneGroup = self.view
    sceneGroup:insert(gameView)
    sceneGroup:insert(gameInfo)
    local map = params.map.map
        for i = 1,#map,1 do 
            ground_array[i] = {}
            for j = 1,#map[i],1 do 
                if(map[i][j] == 1) then
                    ground_array[i][j] = display.newImageRect( "img/game/ground_grass.png", 20, 20 )
                else
                    ground_array[i][j] = display.newImageRect( "img/game/ground_soil.png", 20, 20 )
                end
                ground_array[i][j].x = (j-1)*20
                ground_array[i][j].y = (i-1)*20
                gameView:insert(ground_array[i][j])
            end
        end
        gameView:insert(player)
        game_menu:insert(joystick)
        game_menu:insert(attack)
        game_menu:insert(btn_A)
        game_menu:insert(btn_B)
        gameView:insert(path)

--  spawm NPC
    for i = 1,3,1 do
        table.insert(npc,spawm.npc(math.random(0,100),math.random(0,100)));
        gameView:insert(npc[#npc])
        npc[#npc].myName = "first crate"
        controler.topView(gameView , player)
    end
end

local function update()
    playerControler.main(player , joystick.angle)
    if joystick.angle then
        player.x = player.x + player.speed * math.cos(joystick.angle)
        player.y = player.y + player.speed * math.sin(joystick.angle)
    end
    gameView.x = display.contentCenterX - player.x
    gameView.y = display.contentCenterY - player.y
    bulletUpdate()
    bot.main(npc , player)
end

local function saveGame( event )
    gamedata.saveData({
        player = {x = player.x , y = player.y ,
                 map = {x = 1 , y = 2} },
        map = {x = 1 , y = 1}
 })
end
 
-- show()
function scene:show( event )
    local params = event.params
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        local time = timer.performWithDelay( 500, saveGame, 0 )
        Runtime:addEventListener("enterFrame" , update)
        Runtime:addEventListener("key", key)
        Runtime:addEventListener("axis", axis)
        Runtime:addEventListener("bot", botControler)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end
 
-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        game_menu.isVisible = false
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener("enterFrame" , update)
        Runtime:removeEventListener("key", key)
        Runtime:removeEventListener("axis", axis)
        Runtime:removeEventListener("bot", botControler)
        timer.cancelAll()
    end
end
 
 
-- destroy()
function scene:destroy( event )
    local sceneGroup = self.view
    
    -- Code here runs prior to the removal of scene's view
end
 
 



-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene