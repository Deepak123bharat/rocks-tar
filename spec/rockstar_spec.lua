local tar = require("rocks.tar")
local fs = require("rocks.fs")

describe("Luarocks tar test #unit", function()

   setup(function ()
      fs.init({"linux","unix"})
   end)
    describe("tar.untar", function()
       it("unpacking .tar archives", function()
          local t, result
          t, result = tar.untar("spec/luarocks-3.6.0.tar.gz", "dest")
          print(result)
          assert.truthy(t)
          assert.falsy(result)     
       end)
    end)
end)