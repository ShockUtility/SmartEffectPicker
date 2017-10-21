#
# Be sure to run `pod lib lint SmartEffectPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SmartEffectPicker'
  s.version          = '0.2.3'
  s.summary          = 'A short description of SmartEffectPicker.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

  s.homepage         = 'https://github.com/ShockUtility/SmartEffectPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ShockUtility' => 'shock@docs.kr' }
  s.source           = { :git => 'https://github.com/ShockUtility/SmartEffectPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SmartEffectPicker/Classes/**/*'
  s.resources = "SmartEffectPicker/Assets/*.{xcassets}"

  s.dependency 'GPUImage'
end

# > pod trunk push SmartEffectPicker.podspec --verbose --allow-warnings
