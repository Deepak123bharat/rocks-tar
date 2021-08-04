local tar = require("rocks.tar")

describe("Luarocks tar test #unit", function()

    describe("tar.untar", function()
       it("unpacking .tar archives", function()
          local t, result
          t, result = tar.untar("spec/file.tar", "dest")
          assert.falsy(result)
          assert.truthy(t)
       end)
    end)
end)