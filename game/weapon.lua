local function M (target , Wp)
    local weapon = {}
    weapon['empty'] = {name = 'empty' , type = 'melee' , delay = 1000}
    weapon['gun'] = {name = 'gun' , type = 'range' , delay = 1000}
    target.weapon = weapon[Wp]
end

return M