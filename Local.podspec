Pod::Spec.new do |s|
  s.name                  = 'Xcore'
  s.version               = '1.0.4'
  s.license               = 'MIT'
  s.summary               = 'Cocoa Touch Classes + Extensions'
  s.homepage              = 'https://github.com/zmian/xcore.swift'
  s.authors               = { 'Zeeshan Mian' => 'https://twitter.com/zmian' }
  s.source                = { :path => './' }
  s.source_files          = 'Sources/**/*.swift'
  s.resources             = 'Sources/**/*.xcassets'
  s.requires_arc          = true
  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig   = {
    'SWIFT_VERSION' => '4.1',
    'OTHER_SWIFT_FLAGS' => '-DXCORE_ENVIRONMENT_${CONFIGURATION}'
  }
  s.dependency 'SDWebImage'
  s.dependency 'MDHTMLLabel'
end
