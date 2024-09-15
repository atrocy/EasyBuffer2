local m = {}

export type bufferinfo = {
	buffer: buffer,
	points: {ITEM_NAME: {_startpoint: number, _endpoint: number, value: any, index: any?}?}?,
}

export type data_buffer = buffer

export type funcReturn = {
	read: 'function',
	write: 'function',
	name: 'i8'|'u8'|'i16'|'u16'|'i32'|'u32'|'f32'|'f64'|'string',
	byte: number
}

export type points = {
    last: {},
    points: {}
}

export type point = {
	index: any,
	value: any,
	_startpoint: number,
	_endpoint: number,
	_numindex: number
}

return m