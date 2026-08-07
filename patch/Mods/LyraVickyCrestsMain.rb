if File.exist?('patch/Init/0000.cache_injection.rb') and File.exist?('patch/Init/0000.map_injection.rb') then
  Dir.glob('patch/Mods/LyraVickyCrests/*.rb') do |rb_filename|
    loadScript(rb_filename)
  end
else 
  print("Error, patching libraries not found. Please download 0000.cache_injection.rb and 0000.map_injection.rb from wiresegal's modpack at: github.com/yrsegal/rejuvenation-modpack")
end