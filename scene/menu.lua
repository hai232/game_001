local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 


local function start_game( event )
    if ( ("began" == event.phase) ) then
        composer.gotoScene( "scene.map_load" ,{ params={} })
    end
end
 

-- Create the widget


 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local sceneGroup = self.view

    local button1 = widget.newButton(
    {
        left = 0,
        top = 0,
        width = 50,
        height = 20,
        defaultFile = "img/button/btn_test_over.png",
        overFile = "img/button/btn_test.png",
        id = "button1",
        onEvent = start_game
    }
    )
button1.x = display.screenOriginX + 250
button1.y = display.screenOriginY + display.contentHeight - 50
sceneGroup:insert(button1)
    -- Function to handle button events
    

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
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