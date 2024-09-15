
# EasyBuffer2

### Create buffers, read, update *easily*!

You can get [EasyBuffer2](https://create.roblox.com/store/asset/115321668755697/EasyBuffer2) in Creator Store

Example Usage:

```lua
local EzBuffer = require(path.to.module)

local buff = EzBuffer.new()

buff:Add('CoolIndex', 'Cool')

print(buff:Read().CoolIndex) --> Output: Cool
```