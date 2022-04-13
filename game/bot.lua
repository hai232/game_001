local controler = require('game.function')
M = {}
M.main = function(npc , player)
    for i = 1,#npc,1 do 
        if npc and not npc[i].isDead then
            if controler.Distance(npc[i],player) < 10000 then
                if controler.Distance(npc[i],player) > 100 then
                    if npc[i].sequence ~= "walking" then
                        npc[i]:setSequence( "walking" )
                    end
                end

                if controler.Distance(npc[i],player) < 100 then
                    if npc[i].sequence ~= "hit" then
                        npc[i]:setSequence( "hit" )
                    end
                else
                    npc[i].x = npc[i].x - math.cos(controler.Angle(npc[i],player)) * npc[i].speed
                    npc[i].y = npc[i].y - math.sin(controler.Angle(npc[i],player)) * npc[i].speed
                end
            else 
                if npc[i].sequence ~= "idle" then
                npc[i]:setSequence( "idle" )
                end
            end

            
            
        end
    end
end

M.eachFrame = function(event , player)
    print(player.hp)
    if event.target.sequence == 'hit' and event.target.frame == 3 then
        player.hpBar.width = player.hpBar.width - 10
        player.hpBar.x = player.hpBar.x -5
        player.hp = player.hpBar.width
    end
end

return M