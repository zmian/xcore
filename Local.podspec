Pod::Spec.new do |s|
  s.name                  = 'Xcore'
  s.version               = '1.0.0'
  s.license               = 'MIT'
  s.summary               = 'Swift Toolbox'
  s.homepage              = 'https://github.com/zmian/xcore'
  s.authors               = { 'Zeeshan Mian' => 'https://twitter.com/zmian' }
  s.source                = { :path => './' }
  s.source_files          = 'Sources/**/*.swift'
  s.resources             = 'Sources/**/*.xcassets'
  s.requires_arc          = true
  s.ios.deployment_target = '14.0'
  s.pod_target_xcconfig   = {
    'SWIFT_VERSION' => '5.3',
    'SWIFT_INSTALL_OBJC_HEADER' => 'NO'
  }
  s.dependency 'SDWebImage'
end
