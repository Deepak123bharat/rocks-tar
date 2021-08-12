local tar = require("rocks.tar")
local fs = require("rocks.fs")
local zip = require("rocks.zip")
local lfs = require("lfs")
local sysdetect = require("rocks.sysdetect")

describe("Luarocks tar test #unit", function()

   local file_exists = function (path)
      return lfs.attributes(path, "mode") ~= nil
   end

   local remove_dir
   remove_dir = function(path)
      if file_exists(path) then
         for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
               local full_path = path..'/'..file
   
               if lfs.attributes(full_path, "mode") == "directory" then
                  remove_dir(full_path)
               else
                  os.remove(full_path)
               end
            end
         end
      end
      lfs.rmdir(path)
   end

   local remove_files = function (path, pattern)
      local result_check = false
      if file_exists(path) then
         for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
               if file:find(pattern) then
                  if os.remove(path .. "/" .. file) then
                     result_check = true
                  end
               end
            end
         end
      end
      return result_check
   end

   setup(function ()
      local sys, arc = sysdetect.detect()
      if(sys == "linux") then
         fs.init({sys, "unix"})
      else
         fs.init({sys})
      end
   end)

   describe("zip.gunzip", function()
      it("unpacking .tar.gz archives", function()
         local ok, err
         local archive = fs.absolute_name("spec/luarocks-3.7.0.tar.gz")
         local tar_filename = archive:gsub("%.gz$", "")
         --assert.falsy(file_exists(tar_filename))
         ok, err = zip.gunzip(archive, tar_filename)
         assert.truthy(ok)
         assert.truthy(file_exists(tar_filename)) 
      end)

      it("untar .tar.gz archives", function()
         assert.falsy(fs.is_dir("dest"))
         local ok, err
         ok, err = tar.untar("luarocks-3.7.0.tar.gz", "dest")
         assert.falsy(ok)
         assert.falsy(fs.is_dir("dest"))
      end)

      it("unpacking .tar archives", function()
         local ok, err
         assert.falsy(fs.is_dir("dest"))
         ok, err = tar.untar("luarocks-3.7.0.tar", "dest")
         print(ok, err)
         assert.truthy(ok)
         assert.truthy(fs.is_dir("dest")) 
         remove_dir("dest")
         remove_files("spec","%.tar$")
         assert.falsy(fs.is_dir("dest"))
      end)
   end)
end)