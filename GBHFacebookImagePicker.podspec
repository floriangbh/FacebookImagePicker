Pod::Spec.new do |s|
    s.name             = 'GBHFacebookImagePicker'
    s.version          = '2.0.1'
    s.summary          = 'GBHFacebookImagePicker is Facebook album photo picker written in Swift 3.0. Enjoy !'
    s.description      = 'GBHFacebookImagePicker is Facebook album photo picker written in Swift 3.0 which permit to pick picture in your Facebook album'
    s.homepage         = 'https://github.com/terflogag/GBHFacebookImagePicker'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Florian Gabach' => 'contact@floriangabach.fr' }
    s.source           = { :git => 'https://github.com/terflogag/GBHFacebookImagePicker.git', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'
    s.source_files = 'GBHFacebookImagePicker/Classes/**/*'
    s.resource_bundles = {
        'GBHFacebookImagePicker' => [
            'Images/*.{png}'
        ]
    }
    s.dependency 'FBSDKCoreKit', '~> 4.27.0'
    s.dependency 'FBSDKLoginKit', '~> 4.27.0'
end
