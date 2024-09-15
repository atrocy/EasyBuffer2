local bfr = {
	bytes = {string = 1, float = 2, int = 2},
	functions = {
		i8 = {
			read = buffer.readi8, write = buffer.writei8,
			name = 'i8',
			byte = 2
		},
		u8 = {
			read = buffer.readu8, write = buffer.writeu8,
			name = 'u8',
			byte = 2
		},
		i16 = {
			read = buffer.readi16, write = buffer.writei16,
			name = 'i16',
			byte = 2
		},
		u16 = {
			read = buffer.readu16, write = buffer.writeu16,
			name = 'u16',
			byte = 2
		},
		i32 = {
			read = buffer.readi32, write = buffer.writei32,
			name = 'i32',
			byte = 4
		},
		u32 = {
			read = buffer.readu32, write = buffer.writeu32,
			name = 'u32',
			byte = 4
		},
		f32 = {
			read = buffer.readf32,
			write = buffer.writef32,
			name = 'f32',
			byte = 4
		},
		f64 = {
			read = buffer.readf64,
			write = buffer.writef64,
			name = 'f64',
			byte = 8
		},
		string = {
			read = buffer.readstring,
			write = buffer.writestring,
			name = 'string'
		}
	},
	ranges = {
		[1] = {startpoint = -128, endpoint = 127, name = 'i8'}, [2] = {startpoint = 0, endpoint = 255, name = 'i8'},
		[3] = {startpoint = -32768, endpoint = 32767, name = 'i16'}, [4] = {startpoint = 0, endpoint = 65535, name = 'u16'},
		[5] = {startpoint = -2147483648, endpoint = 2147483647, name = 'i32'}, [6] = {startpoint = 0, endpoint = 4294967295, name = 'u32'},
		[7] = {startpoint = -2147483648, endpoint = 2147483647, name = 'f32'}, [8] = {startpoint = -2^63, endpoint = 2^63-1, name = 'f64'}
	}
}



return bfr