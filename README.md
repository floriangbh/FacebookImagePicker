# GBHFacebookImagePicker

[![CI Status](http://img.shields.io/travis/Florian Gabach/GBHFacebookImagePicker.svg?style=flat)](https://travis-ci.org/Florian Gabach/GBHFacebookImagePicker)
[![Version](https://img.shields.io/cocoapods/v/GBHFacebookImagePicker.svg?style=flat)](http://cocoapods.org/pods/GBHFacebookImagePicker)
[![License](https://img.shields.io/cocoapods/l/GBHFacebookImagePicker.svg?style=flat)](http://cocoapods.org/pods/GBHFacebookImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/GBHFacebookImagePicker.svg?style=flat)](http://cocoapods.org/pods/GBHFacebookImagePicker)

- [⤵️ Installation](#installation)
- [🛠 Usage](#usage)
- [💪🏼 Comming soon improvement](#usage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* Xcode 8 
* iOS 9.0+ target deployment
* FBSDKCoreKit, FBSDKLoginKit (>= 4.0)

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

## Author

Florian Gabach, contact@floriangabach.fr

## License

GBHFacebookImagePicker is available under the MIT license. See the LICENSE file for more info.
