#
# Be sure to run `pod lib lint ResplendentRestkit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ResplendentRestkit"
  s.version          = "0.1.0"
  s.summary          = "A short description of ResplendentRestkit."
  s.description      = <<-DESC
                       An optional longer description of ResplendentRestkit

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/ResplendentRestkit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Richard Reitzfeld" => "richie.reitzfeld@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/ResplendentRestkit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.prefix_header_contents = '#import <CoreData.h>'

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ResplendentRestkit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ResplendentUtilities', '~> 0.2'
  s.dependency 'RestKit', '0.24.1'
end
