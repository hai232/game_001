M = {}
M.Distance = function(object , target)
    if target then
        local distance = (object.x - target.x)*(object.x - target.x) + (object.y - target.y)*(object.y - target.y)
    return distance
    end
end


M.Angle = function(object , target)
    local angle = math.atan2( object.y - target.y, object.x - target.x)
    return angle
end

M.topView = function(object , target)
    object:remove(target)
    object:insert(target)
end

M.Collision = function( obj1, obj2 )
 
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return ( left or right ) and ( up or down )
end

local Collision = function( obj1, obj2 )
    if obj1.own == obj2.class then
    return false
    end
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return ( left or right ) and ( up or down )
end

M.CollisionArr = function(obj1, obj2)
    for i = 1,#obj1,1 do 
        for j = 1,#obj2,1 do 
            if obj1[i].alive and obj2[j] and not obj2[j].isDead then
                if Collision(obj1[i] , obj2[j]) then
                    transition.cancel(obj1[i].tag)
                    obj1[i].alive = false
                    return obj1[i]
                end
            end
        end
    end
end


M.DealDamage = function(obj, target)
    for i = 1,#target,1 do 
        if target[i] and Collision(obj , target[i]) then
            target[i]:addHp(-obj.damage)
        end
    end
end



M.remove_npc = function(npc,index)
    display.remove( npc[index] )
    table.remove(npc,index)
end

return M