local M = {}
M.attack = function (pos , angle , index , weapon)
    local bullet
    if(weapon == 'gun') then
        bullet = display.newGroup()
        local bullet_shell = display.newCircle(bullet,0,0,10)
        local deathCircle = display.newCircle(bullet,0,0,10)
        deathCircle:setFillColor(1,1,0.2)
        bullet.alive = true
        bullet.x = pos.x
        bullet.y = pos.y
        bullet.damage = 30
        bullet.own = pos.class
        bullet.tag = index
        bullet.angle = angle or 0
        function bullet:explode()
            display.remove( bullet_shell ) ; bullet_shell = nil
            local trans1 = transition.to( deathCircle, { time=200, alpha = 0, xScale=3, yScale=3, onComplete=
                function() 
                    bullet.alive = false
                    display.remove( deathCircle ) ; deathCircle = nil
                end} )
            return deathCircle
        end
        transition.to( bullet, { time=1500,
        x=(pos.x + 100*math.cos(bullet.angle)),
        y=(pos.y + 100*math.sin(bullet.angle)) ,
        tag=index,
        onComplete=bullet.explode}
        )
    end


    if(weapon == 'empty') then
        bullet = display.newGroup()
        local bullet_shell = display.newCircle(bullet,0,0,10)
        local deathCircle = display.newCircle(bullet,0,0,10)
        deathCircle:setFillColor(1,1,0.2)
        bullet.alive = true
        bullet.x = pos.x 
        bullet.y = pos.y 
        bullet.own = pos.class
        bullet.damage = 30
        bullet.tag = index
        bullet.angle = angle or 0
        function bullet:explode()
            display.remove( bullet_shell ) ; bullet_shell = nil
            local trans1 = transition.to( deathCircle, { time=200, alpha = 0, xScale=3, yScale=3, onComplete=
                function() 
                    bullet.alive = false
                    display.remove( deathCircle ) ; deathCircle = nil
                end} )
            return deathCircle
        end
        transition.to( bullet, { time=10,
        x=(pos.x + 5*math.cos(bullet.angle)),
        y=(pos.y + 5*math.sin(bullet.angle)) ,
        tag=index,
        onComplete=bullet.explode}
        )
    end


    return bullet
end

return M