local controler = require('game.function')
local pi = math.pi
local M = {}
    M.main = function(player , angle)
        if player.state ~= 'hit' and not player.isDead then
            if angle then
                if(angle > 3*pi/4 or angle < -3*pi/4) then
                    player.direction = '_left'
                    player.angle = math.pi
                end
                if(angle < pi/4 and angle > -pi/4) then
                    player.direction = '_right'
                    player.angle = 0
                end

                if(angle < 3*pi/4 and angle > pi/4) then
                    player.direction = '_down'
                    player.angle = math.pi / 2
                end

                if(angle > -3*pi/4 and angle < -pi/4) then
                    player.direction = '_up'
                    player.angle = -math.pi / 2
                end
            end

            if angle then
                player.state = 'run'
            else player.state = 'idle'
            end
            
            if player.sequence ~= player.state..player.direction then
                player:setSequence( player.state..player.direction )
                end
        end
    end

    M.attack = function()
        
    end


    M.eachFrame = function(event , player)
        if event.target.sequence == 'hit' and event.target.frame == 3 then
            player.hpBar.width = player.hpBar.width - 10
            player.hpBar.x = player.hpBar.x -5
            player.hp = player.hpBar.width
        end
    end
    
return M