local json = require('json')

local path = system.pathForFile('data.json', system.DocumentsDirectory)

local M = {}

M.saveData = function(data)
    local file = io.open(path, 'w')
    if file then
        file:write(json.encode(data))
        io.close(file)
    end
end

M.loadData = function()
    local file = io.open(path, 'r')
    if file then
        data = json.decode(file:read('*a'))
        io.close(file)
    else
        data = {}
    end
    return data
end

return M