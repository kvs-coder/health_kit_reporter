#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint health_kit_reporter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'health_kit_reporter'
  s.version          = '1.1.1'
  s.summary          = 'A new Flutter project.'
  s.swift_versions   = '5.3'
  s.description      = <<-DESC
'Helps to write or read data from Apple Health via HealthKit framework.'
                       DESC
  s.homepage         = 'https://github.com/VictorKachalov/health_kit_reporter'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Victor Kachalov' => 'victorkachalov@gmail.com' }
  s.source           = { :path => '.' }
  s.ios.deployment_target = '12.0'
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'HealthKitReporter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
