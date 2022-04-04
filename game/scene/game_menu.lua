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
    print(event.x)
    print(btn_gotomenu.width)
    if ( "ended" == event.phase ) then
            if event.x > btn_gotomenu.x - btn_gotomenu.width/2 and
            event.x < btn_gotomenu.x + btn_gotomenu.width/2 and
            event.y > btn_gotomenu.y - btn_gotomenu.height/2 and
            event.y < btn_gotomenu.y + btn_gotomenu.height/2 then
            composer.gotoScene( "scene.menu" ,{ params={} })
        end
    end
end

btn_gotomenu:addEventListener( "touch", goto_menu )

game_menu:insert(btn_gotomenu)

local btn_press = widget.newButton(
    {
        width = 30,
        height = 30,
        defaultFile = "img/button/btn_test_over.png",
        overFile = "img/button/btn_test.png",
        id = "button2",
    }
)
btn_press.x = display.contentWidth - 10
btn_press.y = display.contentHeight - 10



local function goto_menu( event )
    print(event.x)
    print(btn_press.width)
    if ( "ended" == event.phase ) then
            if event.x > btn_press.x - btn_press.width/2 and
            event.x < btn_press.x + btn_press.width/2 and
            event.y > btn_press.y - btn_press.height/2 and
            event.y < btn_press.y + btn_press.height/2 then
            composer.gotoScene( "scene.menu" ,{ params={} })
        end
    end
end

btn_press:addEventListener( "touch", goto_menu )

game_menu:insert(btn_press)

return game_menu