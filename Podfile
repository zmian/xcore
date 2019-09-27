platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'Example' do
    pod 'Xcore', :path => './Local.podspec', :inhibit_warnings => false
    pod 'Haring', :git => 'https://github.com/zmian/Haring'

    target 'UnitTests' do
        inherit! :search_paths
    end

    target 'UITests' do
        inherit! :search_paths
    end
end
