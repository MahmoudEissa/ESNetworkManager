<img src="https://github.com/MahmoudEissa/APIClient/blob/master/Chart.png" height="400">



APIClient is a library that depenent on Alamofire that making new work request easly to made with response mappin.
## Version Compatibility
Here is the current Swift compatibility breakdown:

| Swift Version | Network Version |
| ------------- | ------------ |
| 5.X           | master       |


- [Installation](#installation)
- [Usage](#Usage) 
  - [Initializing NetworkRequest](#initializing-NetworkRequest)
  - [Execute Network Request](#APIClient-executes-the-NetworkRequest-with-completion)
  - [Uploading MultiPartFile](#Uploading-MultiPartFile)
  - [Download](#Download-file)
  - [Session Manager](#Session-Manager)
  - [DataResponse Mapping](#DataResponse-Mapping)
  - [JSON](#JSON)
  - [PromiseKit Extensions](#PromiseKit-Extensions)
  - [RxSwift Extensions](#RxSwift-Extensions)
  - [Request Selections](#Request-Selections)
- [Reposne Mapping Support](#Reposne-Mapping-Support) 
  - [Basic types](#Basic-types)
  - [ObjectMapper](#ObjectMapper)
  - [Codabable](#Codabable)
  - [JSONResponseMappable](#JSONResponseMappable)
  - [Another Mapping Tool](#Another-Mapping-Tool)






[releases]: https://github.com/thoughtbot/Argo/releases

## Installation

### CocoaPods

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```
pod 'APIClient', :git => 'https://github.com/MahmoudEissa/APIClient.git'
```

You will also need to make sure you're opting into using frameworks:

```
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.


## Usage

### Initializing NetworkRequest

```swift
let request = NetworkRequest(base: "https://sample.com", path: "api/path")
    request.parameter = [:]
    request.headers = [:]
    request.encoding = JSONEncoding.default
    request.method = .post
    request.selections = []
    print(request)

```
### APIClient executes the NetworkRequest with completion

```swift
func login(email: String, password: String, completion: @escaping Completion<User>) {
    let request = NetworkRequest(base: "https://sample.com", path: "api/login")
    request.parameter = ["email": email, "password": password]
    request.encoding = JSONEncoding.default
    request.method = .post
    APIClient.execute(request: request, completion: completion)
}
login(email: "email", password: "password") { (response) in
    guard case .success(let user) = response else {
            return
    }
    print(user.name)
 }

```

### Uploading MultiPartFile

```swift
func upload(avatar: UIimage, progress: @escaping ProgressHandler, completion: @escaping Completion<String>) {
    let data = avatar.jpegData(compressionQuality: 0.5)!
    let file = MPFile(data: data, key: "file", name: "image.jpeg", memType: "image/jpeg")
    let request = NetworkRequest(base: "https://sample.com", path: "api/upload")
    request.parameter = [:]
    request.encoding = JSONEncoding.default
    request.method = .post
    APIClient.upload(files: [file], request: request, progress: progress, completion: completion)
}
// Example
upload(avatar: image, progress: { (fractionCompleted) in
       
       print(fractionCompleted)
   }) { (response) in
       guard case .success(let imageUrlString) = response else {
           return
       }
       print(imageUrlString)
}
```

### Download file

```swift

func downloadFile() {
    let request = NetworkRequest(base: "https://sample.com", path: "api/file.mp4")
    APIClient.download(request: request, progress: { (fractionCompleted) in
        print(fractionCompleted)
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
extension APIClient {
       static var Manager: SessionManager {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [:]
        return Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
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
extension APIClient {
    static func map(_ response: DataResponse<Any>) -> NetworkResponse<JSON> {
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
    return APIClient.execute(request: request)
}
func getProfile(token: String) -> Promise<User>{
    return APIClient.execute(request: request)
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
     return APIClient.execute(request: request)
 }
 func getProfile(token: String) -> Single<User>{
     return APIClient.execute(request: request)
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
func login(email: String, password: String, completion: @escaping Completion<User>) {

    request.selection = [.key("content")]
    APIClient.execute(request: request, completion: completion)
}

// Example
login(email: "email", password: "password") { (response) in
    guard case .success(let user) = response else {
            return
    }
    print(user.name) // --> Demo User
 }
```
Or

```swift
func login(email: String, password: String, completion: @escaping Completion<String>) {

    request.selection = [.key("content"), .key("token")]
    APIClient.execute(request: request, completion: completion)
}

// Example
login(email: "email", password: "password") { (response) in
    guard case .success(let token) = response else {
            return
    }
    print(token) // --> Token
 }
```
Or

```swift
func login(email: String, password: String, completion: @escaping Completion<String>) {

    request.selection = [.key("content"), .key("phones"), .index(0)]
    APIClient.execute(request: request, completion: completion)
}

// Example
login(email: "email", password: "password") { (response) in
    guard case .success(let phone) = response else {
            return
    }
    print(phone) // --> 01000000000
}
```

## Reposne Mapping Support

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

### Basic types (Dictionary, String, NSNumber, Rawrepresentable, Bool and Array<Base Basic> )

Dictionary
```swift
func test(completion: @escaping Completion<[String: Any]>) {

     request.selection = []
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let json) = response else {
            return
    }
    print(json) // --> dictionary
}
```

String
```swift
func test(completion: @escaping Completion<String>) {

     request.selection = [.key("name")]
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let name) = response else {
            return
    }
    print(name) // --> Demo User
}
```
Array
```swift
func test(completion: @escaping Completion<[String]>) {

     request.selection = [.key("phones")]
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let phones) = response else {
            return
    }
    print(json) // --> ["134234", "532412"]
}
```
### ObjectMapper
```swift
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
func test(completion: @escaping Completion<User>) {

     request.selection = []
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let user) = response else {
            return
    }
    print(user.name) // --> Demo User
}
```

### Codabable 
```swift
class User: Codable {
    var name = ""
    var age = ""
    var activated = false
    private enum CodingKeys: String, CodingKey {
        case name, age, activated
    }
}

func test(completion: @escaping Completion<User>) {

     request.selection = []
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let user) = response else {
            return
    }
    print(user.name) // --> Demo User
}
```
Decoder can be customized 
```swift
class User: Codable {
    var name = ""
    var age = ""
    var activated = false
    private enum CodingKeys: String, CodingKey {
        case name, age, activated
    }
    // Decoder Overriding
    static var decoder: JSONDecoder {
        return JSONDecoder()
    }
}
```

### JSONResponseMappable 
```swift
class User: JSONResponseMappable {
    var name = ""
    var age = ""
    var activated = false
    // Implement JSONResponseMappable Protocol
    required init(json: JSON) throws {
        name = json.name.value() ?? ""
        age = json.age.value() ?? 0
        activated = json.activated.value() ?? fasle
    }
}
func test(completion: @escaping Completion<User>) {

     request.selection = []
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let user) = response else {
            return
    }
    print(user.name) // --> Demo User
}
```

### Another Mapping Tool

```swift
// Mapping Protocol
protocol MappingTool {
    init(json: [String: Any])
}
// Creating Extenion to Protocol implementation
extension ResponseMappable where T: MappingTool {
     static func map(_ response: JSON) throws -> T {
         guard let json = response.object as? [String: Any]  else {
             throw NSError.init(error: "Unable to cast \(response) to Dictionary", code: -1)
         }
         return T.init(json: json)
     }
     static func mapArray(_ response: JSON) throws -> [T] {
         guard let array = response.object as? [[String: Any]]  else {
             throw NSError.init(error: "Unable to cast \(response) to Array", code: -1)
         }
         return array.map({.init(json: $0)})
     }
}

// Declare a class
class User: MappingTool, ResponseMappable {
    var name = ""
    var age = ""
    var activated = false
    required init(json: [String : Any]) {
        name = json["name"] as? String ?? ""
        age = json["age"] as? Int ?? 0
        activated = json["activated"] as? Bool ?? false
    }
  
}

func test(completion: @escaping Completion<User>) {

     request.selection = []
     APIClient.execute(request: request, completion: completion)
}

// Example
test() { (response) in
    guard case .success(let user) = response else {
            return
    }
    print(user.name) // --> Demo User
}

```

## License

APIClient is released under the MIT license. [See LICENSE](https://github.com/MahmoudEissa/APIClient/blob/master/LICENSE) for details.
