
# EasyBuffer2

### Create buffers, read, update *easily*!

Example Usage:

```lua
local EzBuffer = require(path.to.module)

local buff = EzBuffer.new()

buff:Add('CoolIndex', 'Cool')

print(buff:Read().CoolIndex) --> Output: Cool
```