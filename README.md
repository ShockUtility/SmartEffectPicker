# SmartEffectPicker

[![GitHub release](https://img.shields.io/github/release/ShockUtility/SmartEffectPicker.svg)](https://github.com/ShockUtility/SmartEffectPicker)
[![Version](https://img.shields.io/cocoapods/v/SmartEffectPicker.svg?style=flat)](http://cocoapods.org/pods/SmartEffectPicker)
[![License](https://img.shields.io/cocoapods/l/SmartEffectPicker.svg?style=flat)](http://cocoapods.org/pods/SmartEffectPicker)
[![Platform](https://img.shields.io/cocoapods/p/SmartEffectPicker.svg?style=flat)](http://cocoapods.org/pods/SmartEffectPicker)

![Screenshot](https://github.com/ShockUtility/SmartEffectPicker/blob/master/preview.png?raw=true){:height="50%" width="50%"}

<img src="https://github.com/ShockUtility/SmartEffectPicker/blob/master/preview.png?raw=true" width="50%" height="50%">

## Example

Objective-C
```objc
    [SmartEffectPicker startEffect: self
                             title: @"Effect"
                       sourceImage: pickedImage
                         completed: ^(UIImage *effectedImage) {
                             if (effectedImage != nil) {
                                 self.imageView.image = effectedImage;
                             }
                         }];
```
Swift
```swift
    SmartEffectPicker.startEffect(self,
                                  title: "Effect",
                                  sourceImage: pickedImage) { (effectedImage) in
                                      if let image = effectedImage {
                                          self.imageView.image = image
                                      }
                                  }
```

## Requirements

[GPUImage](https://github.com/BradLarson/GPUImage)

## Installation

SmartEffectPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SmartEffectPicker'
```

## Author

ShockUtility, shock@docs.kr

## License

SmartEffectPicker is available under the MIT license. See the LICENSE file for more info.
