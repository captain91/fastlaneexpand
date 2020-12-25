#!/usr/bin/ruby

# path = "fastlane/metadata/"
# tagL = "en"
# en = `trans :#{tagL} file://fastlane/metadata/default/description.txt`
# # en = ""
# puts en
# puts en.empty?

# # exec "touch d1.txt"
# tag_path = path + "ca" + "/description.txt"
# afile = File.new(tag_path,"w") #覆盖写入
# if afile
# 	afile.syswrite(en)
# else
# 	puts "Unable to open file!"
# end
puts !File.zero?("fastlane/metadata/default/release_notes.txt")

puts "kkk_kk"[0,2]