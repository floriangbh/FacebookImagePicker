# GBHFacebookImagePicker

[![Version](https://img.shields.io/cocoapods/v/GBHFacebookImagePicker.svg?style=flat)](http://cocoapods.org/pods/GBHFacebookImagePicker)
[![License](https://img.shields.io/cocoapods/l/GBHFacebookImagePicker.svg?style=flat)](http://cocoapods.org/pods/GBHFacebookImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/GBHFacebookImagePicker.svg?style=flat)](http://cocoapods.org/pods/GBHFacebookImagePicker)

GBHFacebookImagePicker is Facebook album photo picker written in Swift 3.0.

- [🗝 Features](#features)
- [⤵️ Installation](#installation)
- [🛠 Usage](#usage)
- [👓 Translation](#translation)
- [💪🏼 Improvements](#improvements)


## Screenshot

![Preview](https://github.com/terflogag/GBHFacebookImagePicker/raw/master/preview.png)

## Features 

- Login with Facebook SDK and display user's Albums
- Display pictures of each albums 
- Handling denied photo's access 
- Select and get URL of the picked picture 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Don't forgot to replace the current Facebook App's ID with your own in the plist file (Open as > Source code). 
Like this :

```
<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleTypeRole</key>
<string>Editor</string>
<key>CFBundleURLSchemes</key>
<array>
<string>fb<YOUR_FACEBOOK_APP_ID></string>
</array>
</dict>
</array>
<key>FacebookAppID</key>
<string><YOUR_FACEBOOK_APP_ID></string>
```

Just in case, for public application (which can be use in the AppStore), you need to send your Facebook's App in review to have user's photos permission.  

## Requirements

* Xcode 8 
* iOS 9.0+ target deployment
* FBSDKCoreKit, FBSDKLoginKit (>= 4.0)
* Facebook Application, see [usage](#usage) for explaination 

## Installation

GBHFacebookImagePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GBHFacebookImagePicker"
```

## Usage

You need to have set up your application correctly to work with Facebook : https://developers.facebook.com/docs/ios/getting-started

Then, implement the `GBHFacebookImagePickerDelegate` protocol:

```
// MARK: - GBHFacebookImagePicker Protocol

func facebookImagePicker(imagePicker: UIViewController, didSelectImageWithUrl url: String) {
    imagePicker.dismiss(animated: true, completion: nil)

    print("Image URL : \(url)")
}

func facebookImagePicker(imagePicker: UIViewController, didFailWithError error: Error?) {
    print(error.debugDescription)
}

func facebookImagePicker(didCancelled imagePicker: UIViewController) {
    print("Cancelled Facebook Album picker")
}
```

Display picker : 

```
let albumPicker = GBHFacebookImagePicker()
albumPicker.delegate = self
let navi = UINavigationController(rootViewController: albumPicker)
self.present(navi, animated: true)
```

## Translation 

GBHFacebookImagePicker is currently write in english. If you need translation for the permission popup (or whatever thing), just add this line in your localized file  :

```
"Pictures" = "<your_translation>";
"Oups" = "<your_translation>";
"You need to allow photo's permission." =  "<your_translation>";
"Allow" = "<your_translation>";
"Close" = "<your_translation>";
```

## Improvements

Comming soon improvements :
- Caching with images 
- Multiple selection
- Better use of keychain & token for login
- UI 

## Author

Florian Gabach, contact@floriangabach.fr

Inspired by https://github.com/OceanLabs/FacebookImagePicker-iOS

## License

GBHFacebookImagePicker is available under the MIT license. See the LICENSE file for more info.
