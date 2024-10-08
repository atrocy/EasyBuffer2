--[[ https://luau.org/library#buffer-library read on buffers!!!

	By atrocy(aka cheez1i/Romazka57)!!!

	EasyBuffer2 - create, write in, read buffers easily!

	[ Example Usage ] 
	
	 	local EzBuffer = require(path.to.module)

		local buff = EzBuffer.new()
		buff:Add('Test Index', 'hello!!')

		local result = buff:Read()

		print(result, result['Test Index']) --> Output: {...}, hello!!

	[ Documentation ]
		[ Constructor ]
		 	local buff = EzBuffer.new() -> BufferObject
				Returns:
					BufferObject

			local buff = EzBuffer.fromId(id: number) -> BufferObject|nil
				Returns:
					BufferObject or nil

		[ Destructor ]
			buff:Destroy() -> ()

		[ Methods ]
			buff:GetBuffer() -> buffer
				Description:
					Returns BufferObject's buffer
				Returns:
					buffer
				Note:
					Equivalent to buff.buffer

			buff:GetId() -> number
				Description:
					Returns BufferObject's id
				Returns:
					number
				Note:
					Equivalent to buff._id


			buff:Add(index: any, value: any) -> ()
				Description:
					Adds a new index with a value you provided to the buffer

			buff:Update(index: any, newValue: any) -> ()
				Description:
					Updates the index if found with the provided value

			buff:Remove(index: any) -> ()
				Description:
					Removes the index from the buffer


			buff:Find(index: any) -> point
				Description:
					Returns a point type that contains an index and a value and 3 read-only properties.
				Returns:
					Point

			buff:Read() -> {...}
				Description:
					Returns a table with all the index->values you added
				Returns:
					Table


			buff:GetData() -> string
				Description:
					Returns buffer's data in a string, you most likely won't use this method
				Returns:
					string

			buff:GetDataBuffer() -> data_buffer
				Description:
					Returns a buffer with a data inside of it
				Returns:
					buffer
				Note:
					Equivalent to buffer.fromstring(buff:GetData())

			buff:SetToDataBuffer(data_buffer: data_buffer) -> ()
				Description:
					Sets itself to the data_buffer you provided, you can change in between these data buffers, something like snapshots
			
]]


local ezbuff = {}
ezbuff.__index = ezbuff

local buff_instances = {}

--Modules--
local Types = require(script.Types)

local library = require(script.BufferInfo)
local BufferPoints = require(script.BufferPoints)

local funcs = require(script.Private)

--Variables
local DEFAULT_DATA_BUFFER_SEPARATOR_JSON = require(script.DataSeparator)
local SeparatorErr = 'Could not add %s index with a value of %s due to %s being as a data separator.'

--Services
local HttpService = game:GetService('HttpService')

--Types--
type bufferinfo = Types.bufferinfo
type data_buffer = Types.data_buffer
type point = Types.point

--Module--
function ezbuff.new()
    local self = setmetatable({
        buffer = buffer.create(0),
		_id = BufferPoints.id
    }, ezbuff)

	buff_instances[BufferPoints.id] = self

    BufferPoints:add()

    return self
end

function ezbuff.fromId(id: number)
	return buff_instances[id]
end


function ezbuff:GetBuffer(): buffer
	return self.buffer
end

function ezbuff:GetId(): number
	return self._id
end


function ezbuff:Add(index: any, value: any)
    if index == nil or value == nil then return end
	if index == DEFAULT_DATA_BUFFER_SEPARATOR_JSON or value == DEFAULT_DATA_BUFFER_SEPARATOR_JSON then
		error(SeparatorErr:format(index, value, DEFAULT_DATA_BUFFER_SEPARATOR_JSON))
		return
	end

	local points = BufferPoints:get(self:GetId())
	local lastPoint: point = points.last
	if not lastPoint['_endpoint'] then lastPoint = {} lastPoint._endpoint = 0 end

	local func, value = funcs.getFunction(value)

	local curSize = buffer.len(self.buffer)
	local valByte = func.byte or #value

	local newBuff = buffer.create(curSize+valByte)
	buffer.copy(newBuff, 0, self.buffer)

	func.write(newBuff, lastPoint._endpoint, value)

	self.buffer = newBuff
	BufferPoints:addPoint(self:GetId(), {
		index = index,
		value = value,
		_startpoint = lastPoint._endpoint,
		_endpoint = valByte+lastPoint._endpoint
	})
end

function ezbuff:Update(index: any, newValue: any?)
	if index == nil then return end
	if not BufferPoints:get(self:GetId()) then return end

	BufferPoints:removePoint(self:GetId(), index)
	if newValue then self:Add(index, newValue) end
end

function ezbuff:Remove(index: any)
	self:Update(index) --not passing the newValue will remove that index
end


function ezbuff:Read(): {}
	local points = BufferPoints:get(self:GetId()).points

	local data = {}

	for _, point: point in points do
		local func = funcs.getFunction(point.value)

		if func.name == 'string' then
			local val = funcs.parseBoolean(point.value)
			if typeof(val) == 'boolean' then data[point.index] = val continue end
			data[point.index] = func.read(self.buffer, point._startpoint, #val)
		else
			data[point.index] = func.read(self.buffer, point._startpoint)
		end
	end

	return data
end

function ezbuff:Find(index: any): point?
	return BufferPoints:get(self:GetId()).points[index]
end


function ezbuff:GetData(): string
	local buff = self.buffer
	local points = BufferPoints:get(self:GetId())

	return buffer.tostring(buff)..DEFAULT_DATA_BUFFER_SEPARATOR_JSON..HttpService:JSONEncode(points)
end

function ezbuff:GetDataBuffer(): data_buffer
	return buffer.fromstring(self:GetData())
end

function ezbuff:SetToDataBuffer(data_buffer: data_buffer)
	if typeof(data_buffer) ~= 'buffer' then print('oops') return end

	local buff_string = buffer.tostring(data_buffer)

	local startpos, endpos = buff_string:find(DEFAULT_DATA_BUFFER_SEPARATOR_JSON)

	if not startpos then return end
	startpos -= 1

	local buff_actual = buff_string:sub(1, startpos)
	
	self.buffer = buffer.fromstring(buff_actual)
	BufferPoints:setDataPoints(self:GetId(), data_buffer)
end


function ezbuff:Destroy()
	BufferPoints:remove(self:GetId())

	table.clear(buff_instances[self:GetId()])
	buff_instances[self:GetId()] = nil

	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return ezbuff