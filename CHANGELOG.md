Changelog
==========

### 3.1.2

- Bump to FBSDK 5.5.0

### 3.1.1

- Bump to FBSDK 5.4.1

### 3.1.0

- Bump to FBSDK 5.2.3 

### 3.0.2

- Bug fix with facebook picture pagination 

### 3.0.1

- Bug fix with facebook album pagination 

### 3.0.0

- Bump to FBSDK 5.0.0 (contains a lot of breaking change)

### 2.6.0

- Bump to FBSDK 4.42.0
- Swift 5.0

### 2.5.2

- Bump to FBSDK 4.41.2
- Give access to the album image picker (#53)

### 2.5.2

- Bump to FBSDK 4.41.0

### 2.5.1

- Bump to FBSDK 4.40.0

### 2.5.0

Breaking change with configuration. 

- Swift 4.2
- Bump to FBSDK 4.38.1
- Remove every class prefix 
- Remove allowMultipleSelection, use maximumSelectedPictures property instead
- Refactor code with child controller 

### 2.4.1

- Bump to FBSDK 4.37

### 2.4.0

- Add "all selection" feature 
- Moving action button to a toolbar 
- Bump to FBSDK 4.34
- Texts configuration refactoring 
- Layout : refactoring with anchor (to be continue)

Some breaking change can occur with the text localization. 

### 2.3.2

- Bump to FBSDK 4.32

### 2.3.1

- Bump FBSDK to 4.31
- Improve image multiple selection download 

### 2.3.0

- Bump FBSDK to 4.30
- More customisation with `previewPhotoSize` 

### 2.2.1

- Bump FBSDK to 4.29

### 2.2.0

- Add `checkViewBackgroundColor` configuration
- Allow  `selectedBorderWidth` & `selectedBorderColor` configuration

### 2.1.0

- Add selection animation 
- Mode customisation with `showCheckView` and `performTapAnimation`
- Bump FBSDK to 4.28

### 2.0.2

- Bump FBSDK to 4.27.1
- Clean 

### 2.0.1

- Fix simple selection loading

### 2.0

- Swift 4 
- Handle empty album and display placeholder message 
- Add some configuration options
- Update UI for albums and pictures 
- Update UI for pictures selection
- Deprecated `selectedBorderWidth` & `selectedBorderColor` configuration
- Add cache system for image loading 
- Fix some bugs...

### 1.3.1

- Bump FBSDK from v4.24 to v4.26
- Improve cell reusability
- Fix potential memory leak 
- Fix potential multiple tagged album 

### 1.3.0

- Add tagged photos album option 

### 1.2.3

- Fix multiple selection 
- Bump FBSDK Dependency  

### 1.2.2

- Add multiple selection settings  

### 1.2.1

- Bump FBSDK Dependency  

### 1.2.0

- Multiple selection in one album 
- Bump FBSDK Dependency  

### 1.1.8

- Bump FBSDK Dependency 

### 1.1.7

- Customisation way, see https://github.com/terflogag/FacebookImagePicker#customisation section. 

### 1.1.6

- Bump FBSDK Dependency 

### 1.1.5

- Update to Swift 3.1

### 1.1.4

- Bump FBSDK Dependency 

### 1.1.3

- Fix number of picture in album

### 1.1.2

- Add documentation
- Rename GBHFacebookImageModel to GBHFacebookImage
- Rename FacebookAlbumModel to FacebookAlbum

### 1.1.1

- Clean code
- Fix code style for SwiftLint

### 1.1.0

- Make some protocol method optional
- Add image apparition animation 
- Fix code style for SwiftLint

### 1.0.14

- Add dismissed function to the delegate ( https://github.com/terflogag/FacebookImagePicker/pull/8 ) 

### 1.0.13

- Return only image model in the didSelect delegate ( https://github.com/terflogag/FacebookImagePicker/pull/6 )

### 1.0.12

- Update FacebookSDK dependency
- Fixe Facebook login in app 

### 1.0.11

- Add rotation support with autolayout 
- Add SwitLint checker 

### 1.0.8

- Automatically dismiss (#2)

### 1.0.7

- Add customization way
- Safe unwrap 
- Update Facebook's tool dependency 
- Improve exemple

### 1.0.6

- Load album in low quality to improve memory usage, and provide source url/image
- Get selected image (URL & UIImage)

### 1.0.5

- Fixed bugs

### 1.0.4

- Embed picker un navigation controller

### 1.0.3

- Add Facebook app with valid permission for exemple project
- Improve demo 
- Add appearence manager

### 1.0.2

- Add preview
- Add exemple
- Improve image content mode 

### 1.0.1

- Catch denied user_photos permission and ask again for Facebook's permission

### 1.0

- Initial release supporting Swift 3.0
