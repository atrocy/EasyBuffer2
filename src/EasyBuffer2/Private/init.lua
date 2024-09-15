local private_funcs = {}

--Modules--
local library = require(script.Parent.BufferInfo)
local TypesMod = require(script.Parent.Types)

--Types--
type bufferinfo = TypesMod.bufferinfo
type point = TypesMod.point
type funcReturn = TypesMod.funcReturn

--Functions--
function private_funcs.getbytes(value: any)
	local vtype = typeof(value)

	if vtype == 'string' and not tonumber(value) then return #value*library.bytes.string end
	if vtype == 'number' and math.round(value) ~= value then return library.bytes.float end
	if vtype == 'number' or tonumber(value) then return library.bytes.int end

	return #tostring(value)*library.bytes.string
end

function private_funcs.moreThanAndLess(value: number, MoreThan: number, LessThan: number)
	return (value >= MoreThan and value <= LessThan)
end

function private_funcs.isInt(value: number)
	return math.round(value) == value
end

function private_funcs.getLastKey(bufferinfo: bufferinfo)
	local lastkey, lastpoints
	for key, point: point in bufferinfo.points do
		if point._endpoint ~= buffer.len(bufferinfo.buffer) then continue end

		lastkey = key
		lastpoints = point
	end

	return lastkey, lastpoints
end

function private_funcs.getFunction(value: any): funcReturn
    local isInt = private_funcs.isInt
    local moreThanAndLess = private_funcs.moreThanAndLess

	local funcs = library.functions
	local ranges = library.ranges

	local tval = typeof(value)

	if tval == 'string' then return funcs.string, value end
	if tval == 'number' then
		for i, contents in ranges do
			if isInt(value) and moreThanAndLess(value, contents.startpoint, contents.endpoint) then return funcs[contents.name], value end
		end

		if not isInt(value) and moreThanAndLess(value, ranges[7].startpoint, ranges[7].endpoint) then return funcs.f32, value end
		if not isInt(value) and moreThanAndLess(value, ranges[8].startpoint, ranges[8].endpoint) then return funcs.f64, value end
	end

	error('This type of value is NOT supported!')
	return nil
end

return private_funcs