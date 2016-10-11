#
# Be sure to run `pod lib lint ResplendentRestkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ResplendentRestkit'
  s.version          = '0.2.1'
  s.summary          = 'A set of of tools to facilitate common Restkit usage.'

  s.homepage         = 'https://github.com/Resplendent/ResplendentRestkit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = {
                        'Benjamin Maer' => 'ben@resplendent.co',
                        'Richard Reitzfeld' => 'richie.reitzfeld@gmail.com'
                        }

  s.source           = {
            :git => 'https://github.com/Resplendent/ResplendentRestkit.git',
            :tag => "v#{s.version.to_s}"
            }

  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'ResplendentRestkit/Classes/**/*'
  
  s.framework    = 'CoreData'
  s.framework    = 'SystemConfiguration'
  s.framework    = 'MobileCoreServices'
  s.dependency 'ResplendentUtilities', '~> 0.5.0'
  s.dependency 'RestKit', '~> 0.27.0'

end
