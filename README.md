<p align="center">
    <img src="https://github.com/terflogag/FacebookImagePicker/blob/master/Ressources/welcome_img.png" alt="FacebookImagePicker" />
</p>

<p align="center">
    <a href="https://cocoapods.org/pods/GBHFacebookImagePicker" target="_blank"><img src="https://img.shields.io/cocoapods/v/GBHFacebookImagePicker.svg?style=flat" alt="Cocoapods version" /></a>
    <a href="http://cocoapods.org/pods/GBHFacebookImagePicker" target="_blank"><img src="https://img.shields.io/cocoapods/l/GBHFacebookImagePicker.svg?style=flat" alt="Cocoapods licence" /></a>
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
This picker takes care of all authentication (from the web or with the native Facebook app) when necessary. If the photo's permission isn't accepted during the login, the picker prompts another permission's request.

## Screenshot / Demo

![Preview](https://github.com/terflogag/FacebookImagePicker/blob/master/Ressources/preview.png)

## Features 

- [x] Login with Facebook SDK and display user's Albums or tagged photos
- [x] Display pictures of each albums 
- [x] Handling denied Facebook photo's permission 
- [x] Select and get URL/Image of the selected pictures 
- [x] UI Customization 
- [x] AppStore ready
- [x] Swift 3 & Swift 4
- [x] iPhone/iPad support 
- [x] Multiple selection in one album
- [ ] MVC to MVVM (feel free to make PR)
- [ ] Unit & UI Test (feel free to make PR)

## Example

In your terminal :

```ruby
pod try GBHFacebookImagePicker
```

Or to run the example project manually, clone the repo, and run `pod install` from the Example directory first.

Don't forget to replace the current Facebook App's ID with your own in the plist file (Open as > Source code). 
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

## Usage

- You need to set up your application correctly to work with Facebook : https://developers.facebook.com/docs/ios/getting-started and https://developers.facebook.com/docs/ios/ios9

- Import the library : 

```swift
import GBHFacebookImagePicker
```

- Then, implement the `GBHFacebookImagePickerDelegate` protocol :

```swift
// MARK: - GBHFacebookImagePicker Protocol

func facebookImagePicker(imagePicker: UIViewController,
                         successImageModels: [GBHFacebookImage],
                         errorImageModels: [GBHFacebookImage],
                         errors: [Error?]) {
    // Append selected image(s)
    // Do what you want with selected image 
    self.imageModels.append(contentsOf: successImageModels)
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

## Customisation

You can apply some customisation. To do it you can use the GBHFacebookPickerConfig structure like this :

```swift
// Multiple selection settings 
GBHFacebookImagePicker.pickerConfig.allowMultipleSelection = true // False by default  

// Navigation bar title 
GBHFacebookImagePicker.pickerConfig.title = "MyCustomTitle"

// Navigation barTintColor
GBHFacebookImagePicker.pickerConfig.uiConfig.navBarTintColor = UIColor.red

// Close button color 
GBHFacebookImagePicker.pickerConfig.uiConfig.closeButtonColor = UIColor.white

// Global backgroundColor 
GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor = UIColor.red

// Status bar style (.default style by default)
GBHFacebookImagePicker.pickerConfig.uiConfig.statusbarStyle = .lightContent

// Navigation bar title color
GBHFacebookImagePicker.pickerConfig.uiConfig.navTitleColor = UIColor.white

// Navigation bar tintColor
GBHFacebookImagePicker.pickerConfig.uiConfig.navTintColor = UIColor.white

// Album's name color 
GBHFacebookImagePicker.pickerConfig.uiConfig.albumsTitleColor = UIColor.white

// Album's count color 
GBHFacebookImagePicker.pickerConfig.uiConfig.albumsCountColor = UIColor.white

// Selected border color 
GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor = UIColor.red

// Selected border width 
GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth = 4.0

/// Preview photos size (normal by default)
public var previewPhotoSize: ImageSize = .full

// Maximum selected pictures 
GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures = 4

// Display tagged album 
GBHFacebookImagePicker.pickerConfig.taggedAlbumName = "Tagged photos"

// Tagged album name
GBHFacebookImagePicker.pickerConfig.displayTaggedAlbum = true

// Number of picture per row (4 by default)
GBHFacebookImagePicker.pickerConfig.picturePerRow = 3

// Space beetween album photo cell (1.5 by default)
GBHFacebookImagePicker.pickerConfig.cellSpacing = 2.0

// Perform animation on picture tap (true by default)
GBHFacebookImagePicker.pickerConfig.performTapAnimation = true

// Show check style with image and layer (true by default)
GBHFacebookImagePicker.pickerConfig.uiConfig.showCheckView = false

// Change checkview background color
GBHFacebookImagePicker.pickerConfig.uiConfig.checkViewBackgroundColor = UIColor.red
```

## Aditionals informations 

- About tagged photos : the tagged photos are displayed in an album (hide by default, see customisation section to display it) with the name "Photos of You". You can change this default name in the settings. The tagged album's cover is the facebook account profile picture, which are retrieved with a special call to the graph API. 

## Translation 

GBHFacebookImagePicker is currently write in english. If you need translation for the permission popup (or whatever thing), just add this line in your localized file  :

```
"Pictures" = "<your_translation>";
"Oups" = "<your_translation>";
"You need to allow photo's permission." =  "<your_translation>";
"Allow" = "<your_translation>";
"Close" = "<your_translation>";
"Album(s)" = "<your_translation>";
"Photos of You" = "<your_translation>";
```

## Requirements

* Xcode 9
* iOS 9.0+ target deployment
* FBSDKCoreKit, FBSDKLoginKit (>= 4.0)
* Facebook Application, see [usage](#usage) for explaination 
* Swift 3 or Swift 4 project

## Installation

GBHFacebookImagePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GBHFacebookImagePicker", '~> 2.0'

pod "GBHFacebookImagePicker", '~> 1.3.1' # For Swift 3.1
```

## Alternative solutions

Here are some other Facebook's album picker libraries.

- [sanche21/DSFacebookImagePicker](https://github.com/sanche21/DSFacebookImagePicker) 
- [OceanLabs/FacebookImagePicker-iOS](https://github.com/OceanLabs/FacebookImagePicker-iOS) 
- [bradtheappguy/BSFacebookImagePicker](https://github.com/bradtheappguy/BSFacebookImagePicker) 

## Communication

- If you **need help**, open an issue.
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request and **read** the [contributing file](CONTRIBUTING.md).

## Applications

Some applications already use this picker like :
- [Troll Generator](https://itunes.apple.com/fr/app/troll-generator/id1038097542?mt=8)
- [Giraf](https://itunes.apple.com/fr/app/giraf/id1136592561?mt=8)

What about yours ? If your application also use this picker, feel free to contact me or make pull request on the README 😁

## Author

Florian Gabach, florian.gabach@gmail.com

Inspired by [OceanLabs/FacebookImagePicker-iOS](https://github.com/OceanLabs/FacebookImagePicker-iOS) (Objective-C)

## License

GBHFacebookImagePicker is available under the [MIT license](LICENSE).

If your application use this picker consider to add the licence in your Credits/About section. You can use [this library to do it](https://github.com/terflogag/OpenSourceController).
