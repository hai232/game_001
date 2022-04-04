local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local game_menu = require('scene.game_menu')

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local ground_image = {}
local ground_array = {}

local gameCamera = display.newGroup()

local player = display.newImageRect( "img/game/player.png", 20, 40 )
player.x = display.contentCenterX
player.y = display.contentCenterY
local joystick = require('scene.joystick')
-- create()
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen
    

 

-- Create the widget
sceneGroup = self.view
sceneGroup:insert(gameCamera)
sceneGroup:insert(game_menu)
end

local function update()
    if joystick.angle then
        player.x = player.x + math.cos(joystick.angle)
        player.y = player.y + math.sin(joystick.angle)
        gameCamera.x = display.contentCenterX - player.x
        gameCamera.y = display.contentCenterY - player.y
    end
end
 
-- show()
function scene:show( event )
    local params = event.params or {}
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        local map = require("map")
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
                gameCamera:insert(ground_array[i][j])
            end
        end
        print(gameCamera)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        gameCamera:insert(player)
        game_menu:insert(joystick)
        game_menu:insert(joystick.bulb)
        Runtime:addEventListener("enterFrame" , update)
    end
end
 
 
-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener("enterFrame" , update)
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