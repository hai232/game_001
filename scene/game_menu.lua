local widget = require( "widget" )
local composer = require( "composer" )
local game_menu = display.newGroup()


local btn_gotomenu = widget.newButton(
    {
        width = 30,
        height = 30,
        defaultFile = "img/button/btn_test_over.png",
        overFile = "img/button/btn_test.png",
        id = "button2",
    }
)
btn_gotomenu.x = display.screenOriginX +20
btn_gotomenu.y = display.screenOriginY +10

local function goto_menu( event )
    if ( "ended" == event.phase ) then
            if event.x > btn_gotomenu.x - btn_gotomenu.width/2 and
            event.x < btn_gotomenu.x + btn_gotomenu.width/2 and
            event.y > btn_gotomenu.y - btn_gotomenu.height/2 and
            event.y < btn_gotomenu.y + btn_gotomenu.height/2 then
            composer.removeScene( "game" )
            composer.gotoScene( "scene.menu" ,{ params={} })
            
        end
    end
end

btn_gotomenu:addEventListener( "touch", goto_menu )

return game_menu