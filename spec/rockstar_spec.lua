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

   local platform_sets = {
      freebsd = { unix = true, bsd = true, freebsd = true },
      openbsd = { unix = true, bsd = true, openbsd = true },
      solaris = { unix = true, solaris = true },
      windows = { windows = true, win32 = true },
      cygwin = { unix = true, cygwin = true },
      macosx = { unix = true, bsd = true, macosx = true, macos = true },
      netbsd = { unix = true, bsd = true, netbsd = true },
      haiku = { unix = true, haiku = true },
      linux = { unix = true, linux = true },
      mingw = { windows = true, win32 = true, mingw32 = true, mingw = true },
      msys = { unix = true, cygwin = true, msys = true },
      msys2_mingw_w64 = { windows = true, win32 = true, mingw32 = true, mingw = true, msys = true, msys2_mingw_w64 = true },
   }
   
   setup(function ()
      local plats = {}
      local sys, _ = sysdetect.detect()
      if platform_sets[sys] then
         for platforms, _ in pairs(platform_sets[sys]) do
               plats[#plats+1] = platforms
         end
      end
       
      fs.init(plats)
   end)

   describe("zip.gunzip", function()
      it("Checking that it doesn't untar .tar.gz archives", function()
         finally(function ()
            remove_dir("dest")
         end)
         assert.falsy(fs.is_dir("dest"))
         local ok, err
         ok, err = tar.untar("spec/luarocks-3.7.0.tar.gz", "dest")
         assert.falsy(ok)
         assert.falsy(fs.is_dir("dest"))
      end)

      it("unpacking .tar archives", function()
         finally(function ()
            remove_dir("dest")
         end)
         local ok, err
         assert.falsy(fs.is_dir("dest"))
         ok, err = tar.untar("spec/file.tar", "dest")
         assert.falsy(err)
         assert.truthy(ok)
         assert.truthy(fs.is_dir("dest")) 
      end)
   end)
end)