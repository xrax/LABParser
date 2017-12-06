# LABParser


Bidirectional JSON-Dictionary/Object parser development in swift 4.

<p align="center">
    <a href="#requirements">Requirements</a> • <a href="#installation">Installation</a> • <a href="#usage">Usage</a> • <a href="#contribution">Contribution</a> • <a href="#author">Author</a> • <a href="#license-mit">License</a>
</p>

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

#### CocoaPods

Install CocoaPods if it is not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

If you already have cocoapods, update it:
``` bash
$ pod update
```

Go to the directory of your Xcode project, and Create and Edit your Podfile and add _LabParser_:

``` bash
$ cd /path/to/MyProject
$ nano Podfile

platform :ios, '11.0'
use_frameworks!

target 'MyProject' do
 pod 'LABParser', '~> 0.2'
end
```

Install it into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import LABParser` framework into your files.

## Usage

LABParser is a bidirectional JSON-Dictionary/Object parser development in swfit 4.

In order to usage this pod, you need import LABParser into yours model objects. 

LABParser act through a class named ParcelableModel. You must inherits all your models of this class to use properly LABParser. We encourage you to create a BaseModel class to import LABParser only in it. This BaseModel class must be open to allow inherits.

```
import Foundation
import LABParser

open class BaseModel: ParcelableModel {

}
```

Now create your models class.

```
import Foundation

class User: BaseModel {

	var email: String!
	var password: String!

	required init(){
		super.init()
	}

	init(email: String, password: String) {
		super.init()
		self.email = email
		self.password = password
	}
}
```

So, suppose that you receive a JSON User object like this in a variable named data:
```
{
	"email": "limpusra@gmail.com",
	"password": "aom123"
}
```

You can convert it to your swift model with:
```
let user = User()
do {
	user.fromJSON(data)	
} catch {
	print("The string isn't a valid JSON")
}

```
Must use try catch blocks to do error handling.


If you receive a Dictionary representation of your User object you can parser doing:
```
let user = User()
user.fromDictionary(data)
```

Then you can use the object atributes:
```
print("Email user is: /(user.email) and password: /(user.password)")
```

If you receive a dictionary array you can parser it doing: 
```
let userArray: [User] = User.fromDictionaryArray(data)
```

Note that your models atributtes must be exactly same of the JSON/Dictionary key name. However, if you have any key tath doesn't match with the model you can override the function 'customKeysName', create a custom dictionary of keys and return it:
```
override func customKeysName() -> [String: String]? {
	return ["email": "user_email",
			"password": "U.Password"]
}
```



To create a dictionary from a model, your ParcelableModel must be initialized:
```
let user = User(email: "limpusra@gmail.com", password: "aom123")
```

so, create a dictionary it's simple like: 
```
let userDictionary: [String: AnyObject] = user.toDictionary()
```

to create a JSON String from a model:
```
do {
    let jsonString = try user.toJSON()
    print("toJSON: " + jsonString)
} catch {
    print("The model can't be parsed to JSON format")
}
```

## To Consider
- All yours models must inherits from ParcelableModel. To import only in a class, you can create a BaseModel to it and all yours models inherits from BaseModel.
- Your atributtes models must be exactly the same of the JSON/Dictionary key name or you must override the function 'customKeysName' in your model class.
- If you have properties of type Int, Float or Double then you must change these types to NSNumber.
- If you have properties of type Bool, you must initialize these in their declaration. You can convert it to NSNumber too.
- LABParser can parser atributes of ParcelableModel objects type like:
```
import Foundation

class Token: BaseModel {

	var defaultToken: String!
	var attempts: NSNumber?
	var refreshToken: String!

	required init(){
		super.init()
	}
}
```

```
import Foundation

class User: BaseModel {

	var email: String!
	var password: String!
	var token: Token!

	required init(){
		super.init()
	}
}
```
- LABParser can parser arrays of ParcelableModel objects like:
```
{
	"email": "limpusra@gmail.com",
	"password": "aom123",
	"offices": [
		{
			"name": "LAB 1",
			"address": "Street 1"
		}, 
		{
			"name": "LAB 2",
			"address": "Street 2"
		}
	]
}
```
With a propertly model:
```
import Foundation

class Office: BaseModel {

	var name: String!
	var address: String!

	required init(){
		super.init()
	}
}
```

```
import Foundation

class User: BaseModel {

	var email: String!
	var password: String!
	var offices: [Office]!

	required init(){
		super.init()
	}
}
```

## Contribution

This library has created based on ParceSwift library. If you need a parser in Swift 1, 2 or 3, go to https://github.com/sebastian989/ParceSwift.
All contributions are welcome. Just contact us.

## Author 
[Leonardo Armero Barbosa](https://github.com/xrax),
[Sebastián Gómez Osorio](https://github.com/sebastian989)

## License (MIT)

 MIT License

Copyright (c) 2017 Leonardo Armero Barbosa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
