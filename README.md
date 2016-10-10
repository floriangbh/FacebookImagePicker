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

- [x] Login with Facebook SDK and display user's Albums
- [x] Display pictures of each albums 
- [x] Handling denied photo's access 
- [x] Select and get URL of the picked picture 
- [ ] Square image cropper (comming soon)
- [ ] UI Customization (comming soon)
- [ ] Keychain selection for Facebook login (comming soon)
- [ ] Image cache (comming soon)

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
let picker = GBHFacebookImagePicker()
picker.presentFacebookAlbumImagePicker(from: self, delegate: self)
```

## Translation 

GBHFacebookImagePicker is currently write in english. If you need translation for the permission popup (or whatever thing), just add this line in your localized file  :

```
"Pictures" = "<your_translation>";
"Oups" = "<your_translation>";
"You need to allow photo's permission." =  "<your_translation>";
"Allow" = "<your_translation>";
"Close" = "<your_translation>";
"Album(s)" = "<your_translation>";
```

## Author

Florian Gabach, contact@floriangabach.fr

Inspired by https://github.com/OceanLabs/FacebookImagePicker-iOS (Objective-C)

## License

GBHFacebookImagePicker is available under the MIT license.

Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
