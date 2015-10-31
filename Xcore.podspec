Pod::Spec.new do |s|
  s.name         = 'Xcore'
  s.version      = '1.0.1'
  s.license      = { :type => 'MIT' }
  s.summary      = 'Cocoa Touch Classes + Extensions'
  s.homepage     = 'https://github.com/zmian/xcore.swift'
  s.authors      = { 'Zeeshan Mian' => 'https://twitter.com/zmian' }
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/zmian/xcore.swift.git', :tag => s.version}
  s.source_files = 'Source/**/*.swift'
  s.dependency 'SDWebImage', '~> 3.7'
end
