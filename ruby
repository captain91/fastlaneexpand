#!/usr/bin/ruby
require 'find'
require 'fileutils'

languages = [
    "zh-Hans",      # Chinese(Simplified) zh
    # "zh-Hant",    # 繁体中文
    "ja",         # Japanese(日语) ja
    "ko",         # Korean(韩语)  ko
    # "tr",         # Turkish(土耳其) tr
    # "ar-SA",      # Arabic(阿拉伯) ar
    "vi",         # Vietnamese(越南)  vi
    # "ms",         # Malay(马来文) ms
    "th",         # Thai(泰国) th
    # "hi",         # Hindi(印地语) hi
    "id",         # Indonesian(印度尼西亚) id
    "en-US",      # English(美国)en
    # "en-AU",      # English(Australia)(英语-澳大利亚) en
    # "en-CA",      # English(Canada)(英语-加拿大) en
    # "fr-CA",      # French(Canada)(法语-加拿大) fr
    # "es-MX",      # Spanish(Mexico) (西班牙-墨西哥) es
    "en-GB",      # English(U.K.)(英语-英国) en
    # "nl-NL",      # Dutch(荷兰) nl
    "fr-FR",      # French(法语) fr
    "pl",         # Polish(波兰) pl
    "cs",         # Czech(捷克文) cs
    "sk",         # Slovak(斯洛伐克) sk
    "de-DE",      # German(德语) de
    "hu",         # Hungarian(匈牙利) hu
    "ru",         # Russian(俄语) ru
    "uk",         # Ukrainian(乌克兰) uk
    "fi",         # Finnish(芬兰) fi
    "sv",         # Swedish(瑞典) sv
    # "no",         # Norwegian(挪威)  no
    "da",         # Danish(丹麦) da
    # "it",         # Italian(意大利) it
    # "pt-BR",      # Portuguese(Brazil)(葡萄牙-巴西) pt
    "pt-PT",      # Portuguese(Portugal)(葡萄牙) pt
    "es-ES",      # Spanish(Spain)(西班牙) es
    "el",         # Greek(希腊语) el
    "ca",         # Catalan(加泰罗尼亚语) ca
    "hr",         # Croatian(克罗地亚语) hr
    # "ro",         # Romanian(罗马尼亚) ro
    # "he"          # Hebrew(希伯来语) he
]
# all_languages = ["ar-SA", "ca", "cs", "da", "de-DE", "el", "en-AU", "en-CA", "en-GB", "en-US", "es-ES", "es-MX", "fi", "fr-CA", "fr-FR", "he", "hi", "hr", "hu", "id", "it", "ja", "ko", "ms", "nl-NL", "no", "pl", "pt-BR", "pt-PT", "ro", "ru", "sk", "sv", "th", "tr", "uk", "vi", "zh-Hant"]
# all_languages = ["dd","ddd"]
# puts all_languages.length
# if Dir.exist? zh-Hans
# end
# defFile = "./fastlane/screenshots/zh-Hans"
dsFile = "./fastlane/screenshots/"
dmFile = "./fastlane/metadata"

def trans(path,tagLanguage,tagTxt)
    cntent = `trans :#{tagLanguage} file://fastlane/metadata/default/#{tagTxt}.txt`
    puts cntent.length
    if cntent.length < 10
        puts "翻译失败，使用默认值"
        cntent = File.read("fastlane/metadata/default/#{tagTxt}.txt")
    end
    tagPath = path + "/#{tagTxt}.txt"
    File.new(tagPath,"w").syswrite(cntent)
    puts "-------写入文件完成---------"
    sleep(3) #频繁操作翻译会限制 ip
end

def copyImage (languagesArr,mainLanguage,dsFile,dmFile)
    for i in languagesArr do
        next if i == mainLanguage
        #创建元数据文件夹，可以使用默认的 关键字，技术支持，描述，版本更新等
        df = "#{dmFile + "/" + i}"
        if !(Dir.exists? df)
            Dir.mkdir df
        end

        #开始翻译到新建文件
        puts "------正在翻译内容-----"
        tagLanguage = i[0,2] #翻译对应的语言
        tagDescription = "description"
        tagRelease_notes = "release_notes"
        puts "目标语言代码#{tagLanguage}"
        trans df,tagLanguage,tagDescription
        #更新记录不为空就翻译
        if !File.zero?("fastlane/metadata/default/#{tagRelease_notes}.txt")
            trans df,tagLanguage,tagRelease_notes
        end

        #创建屏幕截图文件夹
        mf = "#{dsFile + "/" + i}"
        if !(Dir.exists? mf)
            Dir.mkdir mf
        end
        #copy 图片到目标语言
        defPath = "#{dsFile + mainLanguage}"
        Dir.glob("#{defPath}/*.png") do |file|
            FileUtils.cp "#{file}",mf
        end
    end  
end

def getMainLanguage
    afile = IO.readlines("./fastlane/Snapfile")
    ix = 0
    mainLanuguages = ""
    for i in afile do
        if i.include? "languages(["
            ix = afile.index(i)
        end
        if ix > 0 
            if i.include? "])"
                break
            end
            dd = i.split(',')[0]
            if !(dd.include? "#") && (dd.include? "\"")
                # puts i.split(',')[0]
                mainLanuguages = eval(i.split(',')[0])
            end
        end
    end
    if mainLanuguages.empty?
        puts "---获取主语言失败,检查 Snapfile 文件格式"
        exit #没有主语无法进行
    else
        puts "---获取到主语言为#{mainLanuguages}"
        return mainLanuguages
    end
end
#获取主语言
mainLanguage = getMainLanguage
mainLanuguagesFilePath = dsFile + mainLanguage
puts "主语言路径 #{mainLanuguagesFilePath}"

if !Dir.exists?(mainLanuguagesFilePath)
    puts "---文件不存在---"
    return
end
if Dir["#{mainLanuguagesFilePath}/*"].empty?
    puts "---文件为空文件夹---"
    return
end

puts "------添加 #{languages.length} 个多语言------"
copyImage languages,mainLanguage,dsFile,dmFile
puts "------操作完成，执行上传图片和元数据操作----"
exec "fastlane upload_shots_metadata"

# def copy(from, to)
#   File.open(from) do |input|
#     File.open(to, "w") do |output|
#       output.write(input.read)
#     end
#   end
# end

# def get_png_file(file_path)
# 	Dir.glob("#{file_path}/*.png") do |file|
# 		puts file
# 		FileUtils.cp "#{file}","dd"
# 	end
# end

# list = Dir.entries('zh-Hans')
# list.each_index do |x|
# 	item = list[x]
# 	next if item == '.' or item == '..' or item == '.DS_Store'
# 	puts item
# 	FileUtils.cp "./zh-Hans/#{list[x]}","dd"
# end

# rr = '#{ruby}'
# File.open(rr)
# get_png_file("zh-Hans")

# FileUtils.cp('./zh-Hans/1_APP_IPHONE_65_1.png','dd')

# FileUtils.cp_r('zh-Hans','dd')

# File.copy("zh-Hans","dd")
# def traverse_dir(file_path)
# 	if File.directory? file_path
# 		Dir.foreach(file_path) do |file|
# 			if file != "." and file != ".."
# 				# traverse_dir(file_path + "/" + file)
# 				puts file
# 			end
# 		end
# 	else
# 		puts "File:#{File.basename(file_path)},Size:#{File.size(file_path)}"
# 	end
# end

# traverse_dir("zh-Hans")

# Find.find(dsFile) do |path|
# 	puts path
# 	# puts File.size(path)
# end

# afile = File.new("./fastlane/Snapfile","r")

# if afile
#     content = afile.read()
#     # content.include? "languages"
#     puts content.index("])")
#     puts content.index("languages")
#     puts content[content.index("languages")..content.index("]")]
# else
#     puts "unable to open file!"
# end



















