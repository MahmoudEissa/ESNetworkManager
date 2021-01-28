<img src="https://github.com/MahmoudEissa/ESNetworkManager/blob/master/logo.png" height="400">



ESNetworkManager is a library that depenent on Alamofire that making new work request easly to made with response mappin.
## Version Compatibility
Here is the current Swift compatibility breakdown:

| Swift Version | Network Version |
| ------------- | ------------ |
| 5.X           | master       |


- [Installation](#installation)
- [Usage](#Usage) 
  - [Initializing ESNetworkRequest](#initializing-ESNetworkRequest)
  - [Execute Network Request](#ESNetworkManager-executes-the-ESNetworkRequest-with-completion)
  - [Uploading MultiPartFile](#Uploading-MultiPartFile)
  - [Download](#Download-file)
  - [Session Manager](#Session-Manager)
  - [DataResponse Mapping](#DataResponse-Mapping)
  - [JSON](#JSON)
  - [PromiseKit Extensions](#PromiseKit-Extensions)
  - [RxSwift Extensions](#RxSwift-Extensions)
  - [Request Selections](#Request-Selections)
- [Reposne Mapping Support](#Reposne-Mapping-Support) 
  - [Codable](#Codable)
  - [ObjectMapper](#ObjectMapper)
  - [RawRepresentable](#RawRepresentable)
  - [Other Mapping](#Other-Mapping)






[releases]: https://github.com/thoughtbot/Argo/releases

## Installation

### CocoaPods

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```
pod 'ESNetworkManager'
pod 'ESNetworkManager/Core'
pod 'ESNetworkManager/Promise'
pod 'ESNetworkManager/Rx'
pod 'ESNetworkManager/ObjectMapper'
```

You will also need to make sure you're opting into using frameworks:

```
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.


## Usage

### Initializing ESNetworkRequest

```swift
let request = ESNetworkRequest(base: "https://sample.com", path: "api/path")
    request.parameters = [:]
    request.headers = [:]
    request.encoding = JSONEncoding.default
    request.method = .post
    request.selections = []
    print(request)

```
### ESNetworkManager executes the ESNetworkRequest with completion

```swift
func login(email: String, password: String) {
    let request = ESNetworkRequest(base: "https://sample.com", path: "api/login")
    request.parameters = ["email": email, "password": password]
    request.encoding = JSONEncoding.default
    request.method = .post
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<User>) in
        guard case .success(let user) = response else {
            return
        }
        print(user.name)
    }
}
```

### Uploading MultiPartFile

```swift
func upload(avatar: UIImage) {
    let data = avatar.jpegData(compressionQuality: 0.5)!
    let file = MPFile(data: data, key: "file", name: "image.jpeg", memType: "image/jpeg")
    let request = ESNetworkRequest(base: "https://sample.com", path: "api/upload")
    request.parameters = [:]
    request.encoding = JSONEncoding.default
    request.method = .post
    ESNetworkManager.upload(data: .multipart([file]), request: request, progress: { progress in
        print(progress.frationCompleted)
    }) { (response: ESNetworkResponse<String>) in
         guard case .success(let imageUrlString) = response else {
                  return
              }
              print(imageUrlString)
    }
}
```

### Download file

```swift

func downloadFile() {
    let request = ESNetworkRequest(base: "https://sample.com", path: "api/file.mp4")
    ESNetworkManager.download(request: request, progress: { (progress) in
        print(progress.fractionCompleted)
    }) { (response) in
        guard case .success(let url) = response else {
            return
        }
        print(url.absoluteString)
    }
}
```

### Session Manager

Overriding Session Manager

```swift
class NetworkManager: ESNetworkManager {
    static let session: Session = {
        let manager = ServerTrustManager(evaluators: ["serverurl.com": DisabledEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    override class var Manager: Session {
        return session
    }
}
```
### DataResponse Mapping
DataResponse advanced Mapping
if you have a base response with pre defined errors or an error  server message such the following login responses cases
```swift
let json_success = """
    {
    "status": 200,
    "message": "Welcom",
    "content": {"token": "2e13eer1rt13tvxcvz"}
    }
"""
let json_fail = """
    {
    "status": 1002,
    "message": "Wrong Email or password"
    }
    """
```
Simply override DataResponse Mapping
```swift
class NetworkManager: ESNetworkManager {
    override class func map(_ response: AFDataResponse<Any>) -> ESNetworkResponse<JSON> {
        if let error = response.error {
            return .failure(error)
        }
        let json = JSON(response.value)
        let status: Int = json.status.value() ?? 0
        switch status {
        case 200:
            return .success(json.content)
        case let code:
            return .failure(NSError.init(error: json.message.value() ?? "", code: code))
        }
    }
}

// Example For Wrong Email or password
login(email: "email", password: "password") { (response) in
   guard case .error(let error) = response else {
           return
   }
   print(error.localizedDescription) // --> Wrong Email or password
   print(error.statusCode) // --> 1002
}
```

### JSON

JSON is an enum used like javaScrip object insteed of Dictionary ex
```swift
let dictionary: [String: Any] = ["name": "Demo User",
                                 "age": 41,
                                 "type": 1,
                                 "verified": 0,
                                 "activated": true,
                                 "phones": ["134234", "532412"],
                                 "adddress": ["title": "Cairo", "latitude": "12.23123", "logintude": "41.12323"],
                                 "family": [["name": "Demo Son", "age": 19, "activated": false]]]

let json = JSON(dictionary)

json.name.value() // --> Demo User
json.phones.0.value() // --> 134234
json.adddress.title.value() // --> Cairo
json.family.0.name.value() // -->  Demo Son
```

### PromiseKit Extensions

```swift
import PromiseKit
func login(email: String, password: String) -> Promise<String>{
    return ESNetworkManager.execute(request: request)
}
func getProfile(token: String) -> Promise<User>{
    return ESNetworkManager.execute(request: request)
}
// Example
func login() {
    firstly {
        login(email: "m@m.om", password: "password")
    }.then {
        getProfile(token: $0)
    }.done { (user) in
        print(user.name)
    }.catch { (error) in
        print(error.localizedDescription)
    }
}
```

### RxSwift Extensions
```swift
import RxSwift
 func login(email: String, password: String) -> Single<String>{
     return ESNetworkManager.execute(request: request)
 }
 func getProfile(token: String) -> Single<User>{
     return ESNetworkManager.execute(request: request)
 }
 
// Example
func login() {
    login(email: "m@m.com", password: "password")
    .flatMap({getProfile(token: $0)})
        .subscribe(onSuccess: { (user) in
            print(user.name)
        }) { (error) in
            print(error.localizedDescription)
    }.disposed(by: disposeBag)
}
```

### Request Selections
Selections used for if you want to select certian response as the following
suppose you have json response  after user has logged in successfully

```swift
let response  = """
{
    "staus": 200
    "messase" : "Success"
    "content": {
        "id": 12,
        "name": "Demo User",
        "email": "demo@user.com",
        "token": "Token"
        "phones": ["01000000000", "02000000000"]
    }
}
"""
```
There is no need to create a model like 
```swift
class Model {
    var status: Int?
    var messase: Int?
    var content: User?
}
```
just set the Request Selections ( key or index ) e.x
```swift
func login(email: String, password: String) {
    request.selection = [.key("content")]
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<User>) in
        guard case .success(let user) = response else {
            return
        }
        print(user.name)
    }
}
```
Or

```swift
func login(email: String, password: String) {
    request.selection = [.key("content"), .key("token")]
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<String>) in
        guard case .success(let token) = response else {
            return
        }
        print(token) // --> Token
    }
}
```
Or

```swift
func login(email: String, password: String) {
    request.selection = [.key("content"), .key("phones"), .index(0)]
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<String>) in
        guard case .success(let phone) = response else {
            return
        }
        print(phone) // --> 01000000000
    }
}
```

## Resposne Mapping

- Default Mapping implemented for Codable, ObjectMapper and RawRepresentable

- In such case api response 

```swift
let dictionary: [String: Any] = ["name": "Demo User",
                                 "age": 41,
                                 "type": 1,
                                 "verified": 0,
                                 "activated": true,
                                 "phones": ["134234", "532412"],
                                 "adddress": ["title": "Cairo", "latitude": "12.23123", "logintude": "41.12323"],
                                 "family": [["name": "Demo Son", "age": 19, "activated": false]]]
```

### Codable

Codable
```swift
func login(email: String, password: String) {
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<User>) in
        guard case .success(let user) = response else {
            return
        }
        print(user.name) // --> Demo User
    }
}

class User: Codable {
    var name = ""
    var age = ""
    var activated = false
    private enum CodingKeys: String, CodingKey {
        case name, age, activated
    }
}
```
String
```swift
func login(email: String, password: String) {
    request.selection = [.key("name")]
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<String>) in
        guard case .success(let name) = response else {
            return
        }
        print(name) // --> Demo User
    }
}
```
Array
```swift
func login(email: String, password: String) {
    request.selection = [.key("phones")]
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<[String]>) in
        guard case .success(let phones) = response else {
            return
        }
        print(phones) // --> ["134234", "532412"]
    }
}
```
### ObjectMapper
```swift
func login(email: String, password: String) {
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<User>) in
        guard case .success(let user) = response else {
            return
        }
        print(user.name) // --> Demo User
    }
}
class User: Mappable {
    var name = ""
    var age = ""
    var activated = false
    required init?(map: Map) {}
    func mapping(map: Map) {
        name <- "name"
        age <- "age"
        activated <- "activated"
    }
}
```


### RawRepresentable 
```swift
func login(email: String, password: String) {
    request.selection = [.key("type")]
    ESNetworkManager.execute(request: request) { (response: ESNetworkResponse<UserType>) in
        guard case .success(let type) = response else {
            return
        }
        print(type) // --> UserType.admin
    }
}

enum UserType: Int {
    case admin = 1
}

```
### Other Mapping

```swift
// Mapping Protocol
protocol MappingTool {
    init(json: [String: Any])
}

// SubClassing from ESNetworkResponseMapper<T>
class MappingToolNetworkResponseMapper<T>: ESNetworkResponseMapper<T> where T: MappingTool {
    override func map(_ response: ESNetworkResponse<JSON>, selections: [Selection]) -> ESNetworkResponse<T> {
        guard case .success(var value) = response else {
            return .failure(response.error!)
        }
        value = value[selections]
        guard let json = value.object as? [String: Any] else {
            return .failure(NSError.init(error: "Unable to get json from \(value)", code: -1))
            
        }
        return .success(T.init(json: json))
    }
}

func login(email: String, password: String) {
    ESNetworkManager.execute(request: request,
                             mapper: MappingToolNetworkResponseMapper()) { (response: ESNetworkResponse<MUser>) in
        guard case .success(let user) = response else {
            return
        }
        print(user.name!) // --> Demo User
    }
}

// Declare a class
class MUser: MappingTool {
    var name: String?
    var age: Int?
    required init(json: [String : Any]) {
        name = json["name"] as? String
        age = json["age"] as? Int
    }
}

```

## License

ESNetworkManager is released under the MIT license. [See LICENSE](https://github.com/MahmoudEissa/ESNetworkManager/blob/master/LICENSE) for details.
