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
  s.version          = "0.1.1"
  s.summary          = "A set of of tools to facilitate common Restkit usage."
# s.description      = <<-DESC
#                        An optional longer description of ResplendentRestkit
#
#                        * Markdown format.
#                        * Don't worry about the indent, we strip it!
#                        DESC
  s.homepage         = "https://github.com/Resplendent/ResplendentRestkit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = {
							"Benjamin Maer" => "ben@resplendent.co",
							"Richard Reitzfeld" => "richie.reitzfeld@gmail.com"
}
  s.source           = { :git => "https://github.com/Resplendent/ResplendentRestkit.git", :tag => "v#{s.version}"}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.prefix_header_contents = '#import <SystemConfiguration/SystemConfiguration.h>', '#import <MobileCoreServices/MobileCoreServices.h>'

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ResplendentRestkit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.framework    = 'CoreData'
  s.dependency 'ResplendentUtilities', '~> 0.4.0'
  s.dependency 'RestKit', '~> 0.26.0'
  s.dependency 'AFNetworking', '~> 1.3.4'

end
