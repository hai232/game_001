local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local gamedata = require( "game.gamedata" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local map = require( "game.map" )
local results
local data = gamedata.loadData()
local mapLocation = {}
mapLocation = data.player.map or {x = 1 , y = 1}

-- Create the widget


 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local sceneGroup = self.view
    local background = display.newRect(sceneGroup, 0, 0, 1000, 1000)
    background.fill = {
        type = 'gradient',
        color1 = {0.2, 0.45, 0.8},
        color2 = {0.35, 0.4, 0.5}
    }
    local label = display.newText({
		parent = sceneGroup,
		text = 'LOADING...',
		x = display.contentCenterX+80 , y = display.contentCenterY + 16 ,
		font = native.systemFontBold,
		fontSize = 32
	})
    label.anchorX, label.anchorY = 1, 1
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        timer.performWithDelay(0, function()
            composer.gotoScene("scene.game",{params ={map = map[mapLocation.x][mapLocation.y]} } )
        end)
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