Pod::Spec.new do |s|
    s.name             = 'GBHFacebookImagePicker'
    s.version          = '3.1.6'
    s.summary          = 'GBHFacebookImagePicker is Facebook album photo picker written in Swift. Enjoy !'
    s.description      = 'GBHFacebookImagePicker is Facebook album photo picker written in Swift which permit to pick picture in your Facebook album'
    s.homepage         = 'https://github.com/floriangbh/FacebookImagePicker'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Florian Gabach' => 'florian.gabach@gmail.com' }
    s.source           = { :git => 'https://github.com/floriangbh/FacebookImagePicker.git', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'
    s.source_files = 'GBHFacebookImagePicker/Classes/**/*'
    s.resource_bundles = {
        'GBHFacebookImagePicker' => [
            'Images/*.{png}'
        ]
    }
    s.dependency 'FBSDKCoreKit', '~> 5.11.0'
    s.dependency 'FBSDKLoginKit', '~> 5.11.0'
    s.swift_versions = ['5.0']
end
