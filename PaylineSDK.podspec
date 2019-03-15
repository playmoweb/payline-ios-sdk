#
# Be sure to run `pod lib lint PaylineSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PaylineSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PaylineSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://bitbucket.org/mld_mobile/paylinesdk-ios/src/master/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'payline' => 'support@payline.com' }
  s.source           = { :git => 'https://bitbucket.org/mld_mobile/paylinesdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PaylineSDK/Classes/**/*'

  # s.resource_bundles = {
  #   'PaylineSDK' => ['PaylineSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
end
