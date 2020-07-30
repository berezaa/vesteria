local table = setmetatable({}, { __index = table })

table.index = function(object, value)
    for index, element in pairs(object) do
        if element == value then
            return index
        end
    end
end;

table.merge = function(...)
    local new = {}

    for _, object in pairs({ ... }) do
        for index, value in pairs(object) do
            new[index] = value
        end
    end

    return new
end;

table.reverse = function(object)
    local new = {}

    for index = #object, 1, -1 do
        table.insert(new, object[index])
    end

    return new
end;

table.pull = function(object, value)
    table.remove(object, table.index(object, value))
end;

table.clone = function(object)
    local new = {}

    for index, value in pairs(object) do
        new[index] = value
    end
    
    return new
end;

table.move = function(object, index, position)
    local value = object[index]
    
    if position > index then
        position = position - 1
    end

    table.remove(object, index)
    table.insert(object, position, value)
end;

table.map = function(object, handler)
    local new = {}

    for index, value in pairs(object) do
        local result = handler(value, index)

        if result then
            table.insert(new, result)
        end
    end

    return new
end;

table.find = function(object, handler)
    for _, object in pairs(object) do
        local success, result = pcall(handler, object)
        
        if success and result then
            return object
        end
    end
end;

table.count = function(object)
    local count = 0
    
    for index, value in pairs(object) do
        count = count + 1
    end
    
    return count
end;

return table;