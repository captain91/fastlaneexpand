# This file contains the fastlane.tools configuration
# You can find the documentation at https://docs.fastlane.tools
#
# For a list of all available actions, check out
#
#     https://docs.fastlane.tools/actions
#
# For a list of all available plugins, check out
#
#     https://docs.fastlane.tools/plugins/available-plugins
#

# Uncomment the line if you want fastlane to automatically update itself
# update_fastlane

default_platform(:ios)

platform :ios do
  desc "Push a new release build to the App Store"
  lane :release do
    build_app(scheme: "FastlaneTest")
    upload_to_app_store
  end

  desc "截图"
  lane :screenshots do
    snapshot(
      skip_open_summary: true
    )
  end

  desc "获取App Store截图"
  lane :download_s do
  exec "fastlane deliver download_screenshots --force"
  end

  desc "获取App Store元数据"
  lane :download_m do
  exec "fastlane deliver download_metadata"
  end

  desc "只上传截图"
  lane :upload_shots_metadata do 
  	upload_to_app_store(
  		platform: "ios",
  		force: true,
  		skip_metadata: false,
      skip_binary_upload: true,
  		skip_screenshots: false,
  		overwrite_screenshots: true,
  		precheck_include_in_app_purchases: false,
  	)
  end
end
