platform :ios, '10.0'
inhibit_all_warnings! # ignore all warnings from all pods
use_frameworks!

target 'Example' do
  pod 'Xcore',  :path => './Xcore_Local.podspec'

  target 'Tests' do
    inherit! :search_paths
  end
end
