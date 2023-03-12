#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint health_kit_reporter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name                  = 'health_kit_reporter'
  s.version               = '2.1.0'
  s.summary               = 'HealthKitReporter. A wrapper for HealthKit framework. A Flutter plugin'
  s.swift_versions        = '5.3'
  s.description           = 'Helps to write or read data from Apple Health via HealthKit framework using Flutter.'
  s.homepage              = 'https://github.com/VictorKachalov/health_kit_reporter'
  s.license               = { :type => 'MIT', :file => '../LICENSE' }
  s.author                = { 'Victor Kachalov' => 'victorkachalov@gmail.com' }
  s.source                = { :path => '.' }
  s.social_media_url      = 'https://twitter.com/Victor_Kachalov'
  s.ios.deployment_target = '9.0'
  s.source_files          = 'Classes/**/*'
  s.platform              = :ios, '9.0'

  s.dependency 'Flutter'
  s.dependency 'HealthKitReporter', '3.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
