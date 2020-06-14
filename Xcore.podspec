Pod::Spec.new do |s|
  s.name                  = 'Xcore'
  s.version               = '1.0.0'
  s.license               = 'MIT'
  s.summary               = 'Swift Toolbox'
  s.homepage              = 'https://github.com/zmian/xcore.swift'
  s.authors               = { 'Zeeshan Mian' => 'https://twitter.com/zmian' }
  s.source                = { :git => 'https://github.com/zmian/xcore.swift.git', :tag => s.version }
  s.source_files          = 'Sources/**/*.swift'
  s.resources             = 'Sources/**/*.xcassets'
  s.requires_arc          = true
  s.ios.deployment_target = '12.0'
  s.pod_target_xcconfig   = {
    'SWIFT_VERSION' => '5.1'
  }
  # Fixed iOS 12 simulator runtime error: dyld: Library not loaded: /System/Library/Frameworks/CryptoKit.framework/CryptoKit
  # https://forums.swift.org/t/conditionally-use-cryptokit/30138/2
  # Only needed if the `deployment_target` < 13
  s.weak_frameworks = 'CryptoKit'
  s.dependency 'SDWebImage'
end
