local points = {}
points.id = 1
points.points = {}
points.indexnums = {}

local HttpService = game:GetService('HttpService')
local Types = require(script.Parent.Types)

local separator = require(script.Parent.DataSeparator)

type points = Types.points
type point = Types.point
type data_buffer = Types.data_buffer

function points:add()
    self.points[points.id] = {last = {}, points = {}}
    self.indexnums[points.id] = {curindex = 1, indexes = {}}

    self.id += 1
end

function points:get(id): points
    return self.points[tonumber(id) or 0]
end

function points:remove(id)
    if self.points[id] then table.clear(self:get(id)) self.points[id] = nil self.indexnums[id] = nil end
end

function points:addPoint(id, point: point)
    local pointFound = self:get(id)
    if not pointFound then return end
    point._numindex = self.indexnums[id].curindex

    pointFound.points[point.index] = point
    pointFound.last = point

    self.indexnums[id].indexes[self.indexnums[id].curindex] = point.index
    self.indexnums[id].curindex += 1

    table.insert(self.indexnums[id].indexes, point.index)
end

function points:removePoint(id, index: any)
    local pointFound = self:get(id)
    if not pointFound then return end

    local indexPoint = pointFound.points[index]
    if indexPoint then
        if pointFound.last._endpoint == indexPoint._endpoint then pointFound.last = self:get(id)['last'] end

        for i = indexPoint._numindex+1, -1 do
            local pointIndex = points.indexnums[id].indexes[i]
            if not pointIndex then return end

            local point: point = pointFound.points[pointIndex]
            if not point then continue end

            point._startpoint -= #tostring(point.value)
            point._endpoint -= #tostring(point.value)
        end

        pointFound.points[index] = nil
        return indexPoint._startpoint, indexPoint._endpoint
    end
end

function points:setDataPoints(id, data_buffer: data_buffer)
    local pointFound = self:get(id)
    if not pointFound then return end

    local buff_string = buffer.tostring(data_buffer)

    local _, endp = buff_string:find(separator)
	if not endp then return end
	endp += 2
	
	local points_decoded: points = HttpService:JSONDecode(buff_string:sub(endp, -1))

    self.points[id].points = points_decoded.points
    self.points[id].last = points_decoded.last
end

return points