platform :ios, '9.0'
inhibit_all_warnings! # ignore all warnings from all pods
use_frameworks!

target 'Example' do
    pod 'Xcore', :path => './Local.podspec'

    target 'UnitTests' do
        inherit! :search_paths
    end

    target 'UITests' do
        inherit! :search_paths
    end
end
