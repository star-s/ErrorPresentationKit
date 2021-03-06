#
# Be sure to run `pod lib lint ErrorPresentationKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ErrorPresentationKit'
  s.version          = '0.2.3'
  s.summary          = 'iOS implementation of the error handling mechanisms available in the macOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS implementation of the error handling mechanisms available in the macOS.
It covers error object presentation and recovery as described in Error Handling Programming Guide For Cocoa.
                       DESC

  s.homepage         = 'https://github.com/star-s/ErrorPresentationKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergey Starukhin' => 'star.s@me.com' }
  s.source           = { :git => 'https://github.com/star-s/ErrorPresentationKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'ErrorPresentationKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ErrorPresentationKit' => ['ErrorPresentationKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.module_map = 'ErrorPresentationKit/ErrorPresentationKit.modulemap'

end
