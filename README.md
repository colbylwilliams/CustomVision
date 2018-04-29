# CustomVision
Swift SDK for Microsoft's [Custom Vision Service](https://azure.microsoft.com/en-us/services/cognitive-services/custom-vision-service/)


## Features

- [x] [Custom Vision Training API 1.2](https://southcentralus.dev.cognitive.microsoft.com/docs/services/f2d62aa3b93843d79e948fe87fa89554/operations/5a3044ee08fa5e06b890f11f)
- [x] [Custom Vision Prediction API 1.1](https://southcentralus.dev.cognitive.microsoft.com/docs/services/57982f59b5964e36841e22dfbfe78fc1/operations/5a3044f608fa5e06b890f164)
- [x] Work with `UIKit` & `Foundation` objects like `UIImage`
- [x] Export & Download `CoreML` models for use offline
- [ ] Sample App

## Requirements
- iOS 11.0+ / Mac OS X 10.11+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 9.3+
- Swift 4.1+
- [Custom Vision](https://www.customvision.ai/) Account


## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Willow into your Xcode project using Carthage, specify it in your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "colbylwilliams/CustomVision"
```

Run `carthage update` to build the framework and drag the built `CustomVision.framework` into your Xcode project.

### CocoaPods

_Coming soon_

### Swift Package Manager

_Coming soon_


## Usage

To get started using CustomVision, you need to provide the SDK with your [Training Key](https://www.customvision.ai/projects#/settings) and [Prediction Key](https://www.customvision.ai/projects#/settings).

If you're working with a single [project](https://www.customvision.ai/projects), you can also provide a default Project ID that will be used for every project operation _(instead of passing it in as a parameter every time)_.

There are two ways to provide the Training Key, Prediction Key, and Project ID; programmatically, or by adding them to a plist file:

### Programmatically

The simplest way to provide these values and start using the SDK is to set the values programmatically:

```
CustomVisionClient.defaultProjectId     = "CUSTOM_VISION_PROJECT_ID"
CustomVisionClient.shared.trainingKey   = "CUSTOM_VISION_TRAINING_KEY"
CustomVisionClient.shared.predictionKey = "CUSTOM_VISION_PREDICTION_KEY"

CustomVisionClient.shared.getIterations { r in
    // r.resource is [Iteration]
}
```


### Plist File

Alternatively, you can provide these values in your project's `info.plist`, a separate [`CustomVision.plist`](https://github.com/colbylwilliams/CustomVision/blob/master/CustomVision/CustomVision.plist), or provide the name of your own plist file to use.

Simply add the `CustomVisionTrainingKey`, `CustomVisionPredictionKey`, and `CustomVisionProjectId` keys and provide your Training Key, Prediction Key, and default Project ID respectively.

**_Note: This method is provided for convenience when quickly developing samples and is not recommended to ship these values in a plist in production apps._**

#### Info.plist

```
...
<dict>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CustomVisionProjectId</key>
    <string>CUSTOM_VISION_PROJECT_ID</string>
    <key>CustomVisionTrainingKey</key>
    <string>CUSTOM_VISION_TRAINING_KEY</string>
    <key>CustomVisionPredictionKey</key>
    <string>CUSTOM_VISION_PREDICTION_KEY</string>
...
```

#### CustomVision.plist

Or add a [`CustomVision.plist`](https://github.com/colbylwilliams/CustomVision/blob/master/CustomVision/CustomVision.plist) file.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CustomVisionProjectId</key>
    <string>CUSTOM_VISION_PROJECT_ID</string>
    <key>CustomVisionTrainingKey</key>
    <string>CUSTOM_VISION_TRAINING_KEY</string>
    <key>CustomVisionPredictionKey</key>
    <string>CUSTOM_VISION_PREDICTION_KEY</string>
</dict>
</plist>
```

#### Named plist

Finally, you can `CustomVisionTrainingKey`, `CustomVisionPredictionKey`, and `CustomVisionProjectId` key/values to any plist in your project's **main bundle** and provide the name of the plist:

```swift
CustomVisionClient.shared.getKeysFrom(plistNamed: "SuperDuperDope")
```

## Training Images

The CustomVision SDK adds several convenience functions to make uploading new training images to your project as easy as possible.

This example demonstrates creating a new Tag in the Custom Vision project, then uploading several new training images to the project, tagging each with the newly created tag:

```swift
let client = CustomVisionClient.shared

let tag = "New Tag"     // doesn't exist in project yet
let images: [UIImage] = // several UIImages

client.createImages(from: images, withNewTagNamed: name) { r in
    // r.resource is ImageCreateSummary
}
```

## Export & Download CoreML models

One of the most useful features of this SDK is the ability to re-train your Project, export the newly trained model (Iteration), download to the phone's file system, and compile the model on-device for use with `CoreML`.

```swift
func updateUser(message: String) {
    // update user
}

let client = CustomVisionClient.shared 

client.trainAndDownloadCoreMLModel(withName: "myModel", progressUpdate: updateUser) { (success, message) in

}
```

Once the compiled model is persisted to the devices filesystem (above) you get the url of the model using the client's `getModelUrl()` func:

```swift
if let url = client.getModelUrl() {
    let myModel = try MLModel(contentsOf: url)
}
```


## License
Licensed under the MIT License.  See [LICENSE](License) for details.
