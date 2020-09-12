platform :ios, '14.0'
use_frameworks!
inhibit_all_warnings!

target 'Example' do
    pod 'Haring', :git => 'https://github.com/zmian/Haring'
    pod 'Xcore', :path => './Local.podspec', :inhibit_warnings => false

    target 'UnitTests' do
        inherit! :search_paths
    end

    target 'UITests' do
        inherit! :search_paths
    end
end
