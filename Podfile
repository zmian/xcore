platform :ios, '14.0'
use_frameworks!
inhibit_all_warnings!

target 'Example' do
    pod 'Xcore', :path => './Local.podspec', :inhibit_warnings => false
    pod 'SnapKit'

    target 'UnitTests' do
        inherit! :search_paths
    end

    target 'UITests' do
        inherit! :search_paths
    end
end
