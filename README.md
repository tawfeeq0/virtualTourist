## Installation
This app will downloads and stores images from Flickr. The app will allow users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.

## Requirements
- iOS 12.1+
- Xcode 10.1
- swift 4.2
- CoreData
- MapKit

## Installation
You can use [CocoaPods](http://cocoapods.org/) to install `Alamofire` and `Kingfisher` by adding it to your `Podfile`:

```ruby
platform :ios, '12.1'
use_frameworks!
pod 'Alamofire'
pod 'Kingfisher'
```

To get the full benefits import `Alamofire` and `Kingfisher` wherever you import UIKit

``` swift
import UIKit
import Alamofire
import Kingfisher
```
## Usage

- the user can drop pins on a map by long press

<img width="364" alt="screen shot 2019-02-04 at 9 18 13 pm" src="https://user-images.githubusercontent.com/31381556/52228304-16565080-28c3-11e9-9372-88a2f5060ead.png">

- user can press on the pin in order to retrieve the photos around the area

<img width="365" alt="screen shot 2019-02-04 at 9 18 40 pm" src="https://user-images.githubusercontent.com/31381556/52228312-1fdfb880-28c3-11e9-8e22-1a7a71db828b.png">

- if the user interested to get different photos in the same location, he can click on the **New Collection** button

<img width="363" alt="screen shot 2019-02-04 at 9 19 00 pm" src="https://user-images.githubusercontent.com/31381556/52228323-253d0300-28c3-11e9-9ba8-42ab33a2ff27.png">
