local math = setmetatable({}, { __index = math })

math.round = function(number, decimal)
    local multiplier = 10 ^ (decimal or 0)
    return math.floor(number * multiplier + 0.5) / multiplier
end;

math.map = function(number, minimum, maximum, newMinimum, newMaximum)
    return (((number - minimum) * (newMaximum - newMinimum)) / (maximum - minimum)) + newMinimum
end;

math.deltaAngle = function(current, target)
    local delta = (target - current) % (math.pi * 2)

    if delta > math.pi then
        delta = delta - (math.pi * 2)
    end

    return delta
end;

math.rotate = function(vector, angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)

    return Vector2.new(
        vector.X * cos + vector.Y * sin,
        -vector.X * sin + vector.Y * cos
    )
end;

math.side = function(A, B, point)
    return -((B.X - A.X) * (point.Y - A.Y) - (B.Y - A.Y) * (point.X - A.X))
end;

math.lerp = function(a, b, c)
    return a + (b - a) * c
end;

return math