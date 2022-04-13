-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
-- Your code here
composer.recycleOnSceneChange = true
system.activate( "multitouch" )
composer.gotoScene( "scene.menu" ,{ params={} })