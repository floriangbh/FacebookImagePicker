<p align="center">
    <img src="https://github.com/terflogag/FacebookImagePicker/blob/master/Ressources/welcome_img.png" alt="FacebookImagePicker" />
</p>

<p align="center">
    <a href="http://cocoapods.org/pods/GBHFacebookImagePicker" target="_blank"><img src="https://img.shields.io/cocoapods/v/GBHFacebookImagePicker.svg?style=flat" alt="Cocoapods version" /></a>
    <a href="http://cocoapods.org/pods/GBHFacebookImagePicker" target="_blank"><img src="https://img.shields.io/cocoapods/l/GBHFacebookImagePicker.svg?style=flat" alt="Cocoapods licence" /></a>
    <a href="http://cocoapods.org/pods/GBHFacebookImagePicker" target="_blank"><img src="https://travis-ci.org/terflogag/FacebookImagePicker.svg?branch=master" alt="Travis CI" /></a>
    <a href="http://cocoapods.org/pods/GBHFacebookImagePicker" target="_blank"><img src="https://img.shields.io/cocoapods/p/GBHFacebookImagePicker.svg?style=flat" alt="Cocoapods plateform" /></a>
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="Prs welcome" />
</p>

<p align="center">
    <a href="#features">Features</a>
  • <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#translation">Translation</a>
  • <a href="#license">License</a>
</p>

GBHFacebookImagePicker is ***Facebook's*** album photo picker written in Swift, built to provide a simple way to pick picture into Facebook account. The picker provides a simple interface like the native iOS photo picker. 
This picker takes care of all authentication (from the web or with the native Facebook app) when necessary. It the photo's permission isn't accepted during the login, the picker prompts another permission's request. 

## Screenshot / Demo

Video demonstration -> https://vimeo.com/192823627

![Preview](https://github.com/terflogag/FacebookImagePicker/blob/master/Ressources/preview.png)

## Features 

- [x] Login with Facebook SDK and display user's Albums
- [x] Display pictures of each albums 
- [x] Handling denied Facebook photo's permission 
- [x] Select and get URL/Image of the picked picture 
- [x] UI Customization 
- [x] AppStore ready
- [x] Swift 3 
- [x] iPhone/iPad support  
- [ ] Carthage support (feel free to make PR)
- [ ] Unit & UI Test (feel free to make PR)
- [ ] Multiple selection (feel free to make PR)

## Example

In your terminal :

```ruby
pod try GBHFacebookImagePicker
```

Or to run the example project manually, clone the repo, and run `pod install` from the Example directory first.

Don't forgot to replace the current Facebook App's ID with your own in the plist file (Open as > Source code). 
Like this :

```xml
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
* Swift 3 project 

## Installation

GBHFacebookImagePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GBHFacebookImagePicker"
```

## Usage

- You need to set up your application correctly to work with Facebook : https://developers.facebook.com/docs/ios/getting-started and https://developers.facebook.com/docs/ios/ios9

- Import the library : 

```swift
import GBHFacebookImagePicker
```

- Then, implement the `GBHFacebookImagePickerDelegate` protocol :

```swift
// MARK: - GBHFacebookImagePicker Protocol

func facebookImagePicker(imagePicker: UIViewController, imageModel: GBHFacebookImage) {
    print("Image URL : \(imageModel.fullSizeUrl), Image Id: \(imageModel.imageId)")
    if let pickedImage = imageModel.image {
        self.pickerImageView.image = pickedImage
    }
}

func facebookImagePicker(imagePicker: UIViewController, didFailWithError error: Error?) {
    print("Cancelled Facebook Album picker with error")
    print(error.debugDescription)
}

// Optional
func facebookImagePicker(didCancelled imagePicker: UIViewController) {
    print("Cancelled Facebook Album picker")
}

// Optional
func facebookImagePickerDismissed() {
    print("Picker dismissed")
}
```

The imageModel contain : 

```swift
public class GBHFacebookImage {
    public var image: UIImage? // The image, not nil only if image is selected
    public var normalSizeUrl: String? // Normal size picture url
    public var fullSizeUrl: String? // Full size source picture url
    public var imageId: String? // Picture id
}
```

- Display picker : 

```swift
let picker = GBHFacebookImagePicker() 
picker.presentFacebookAlbumImagePicker(from: self, delegate: self) 
```

## Customization 

The are three style : .facebook (default style), .light & .dark.

```swift
GBHFacebookImagePicker.pickerConfig.ui.style = .facebook
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

## Alternative solutions

Here are some other Facebook's album picker libraries.

- [sanche21/DSFacebookImagePicker](https://github.com/sanche21/DSFacebookImagePicker) 
- [OceanLabs/FacebookImagePicker-iOS](https://github.com/OceanLabs/FacebookImagePicker-iOS) 
- [bradtheappguy/BSFacebookImagePicker](https://github.com/bradtheappguy/BSFacebookImagePicker) 

## Applications

Some applications already use this picker like :
- [Troll Generator](https://itunes.apple.com/fr/app/troll-generator/id1038097542?mt=8)
- [Giraf](https://itunes.apple.com/fr/app/giraf/id1136592561?mt=8)

What about yours ? If your application also use this picker, feel free to contact me or make pull request on the README 😁

## Author

Florian Gabach, contact@floriangabach.fr

Inspired by [OceanLabs/FacebookImagePicker-iOS](https://github.com/OceanLabs/FacebookImagePicker-iOS) (Objective-C)

## License

GBHFacebookImagePicker is available under the [MIT license](LICENSE).
