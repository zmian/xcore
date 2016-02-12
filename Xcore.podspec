Pod::Spec.new do |s|
  s.name                  = 'Xcore'
  s.version               = '1.0.3'
  s.license               = 'MIT'
  s.summary               = 'Cocoa Touch Classes + Extensions'
  s.homepage              = 'https://github.com/zmian/xcore.swift'
  s.authors               = { 'Zeeshan Mian' => 'https://twitter.com/zmian' }
  s.source                = { :git => 'https://github.com/zmian/xcore.swift.git', :tag => s.version }
  s.source_files          = 'Sources/**/*.swift'
  s.resources             = 'Sources/*.xcassets'
  s.requires_arc          = true
  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig   = { 'OTHER_SWIFT_FLAGS' => '-DXCORE_ENVIRONMENT_${CONFIGURATION}' }
  s.dependency 'SDWebImage', '~> 3.7'
  s.dependency 'TZStackView', '~> 1.0'
  s.dependency 'BEMCheckBox', '~> 1.0'
  s.dependency 'MDHTMLLabel', '~> 1.0'
end
