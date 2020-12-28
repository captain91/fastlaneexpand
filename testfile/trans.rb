#!/usr/bin/ruby
require 'fileutils'
 # path = "fastlane/metadata/"
 # tagL = "en"
 # en = `trans :#{tagL} file://description.txt`
 # # en = ""
 # puts en
 # puts en.length
 # if en.length < 10 
 # 	puts "小于 10"
 # 	en = File.read("description.txt")
 # 	# en = afile.sysread(20)
 # 	puts en
 # end

 def getAllLanguages
    afile = IO.readlines("Languagefile")
    ix = 0
    lanuguagesAry = []
    for i in afile do
        if i.include? "languages(["
            ix = afile.index(i)
        end
        if ix > 0 
            if i.include? "])"
                break
            end
            dd = i.split(',')[0]
            # puts dd
            if !(dd.include? "#") && (dd.include? "\"")
                # puts i.split(',')[0]
                language = eval(i.split(',')[0])
                lanuguagesAry.push(language)
            end
        end
    end
    if lanuguagesAry.empty?
        puts "---请在Languagefile文件中解注释多语言---"
        exit #没有主语无法进行
    else
        puts "---获取到主语言为#{lanuguagesAry.length}个----"
        return lanuguagesAry
    end
end

#获取主语言
# mainLanguage = getAllLanguages
# puts mainLanguage

if !File.zero?("description.txt")
    puts "kkkk"
end

if !File.zero?("release_notes.txt")
    puts "kkkk"
end

# FileUtils.cp_r "dd","ff"

#  # exec "touch d1.txt"
#  tag_path = path + "ca" + "/description.txt"
#  afile = File.new(tag_path,"w") #覆盖写入
#  if afile
#  	afile.syswrite(en)
#  else
#  	puts "Unable to open file!"
#  end
# puts !File.zero?("fastlane/metadata/default/release_notes.txt")

# puts "kkk_kk"[0,2]
