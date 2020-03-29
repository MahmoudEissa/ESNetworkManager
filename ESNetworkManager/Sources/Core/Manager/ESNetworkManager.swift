
//  Created by Mahmoud Eissa on 12/14/17.
//  Copyright © 2017 Asgatech. All rights reserved.

import Alamofire

public typealias ProgressHandler = (_ fractionCompleted: Double) -> Void
public typealias Completion<T> = (_ response: ESNetworkResponse<T>) -> Void

open class ESNetworkManager {
    open class var Manager: Session {
        return .default
    }
        
    open class func map(_ response: AFDataResponse<Any>) -> ESNetworkResponse<JSON> {
        if let responseError = response.error {
            return .failure(responseError)
        }
        print(response)
        let response = JSON(response.value)
        return .success(response)
    }
}
// MARK: - Session
internal extension ESNetworkManager {
    static func startRequest(request: ESNetworkRequest,
                             completion: @escaping Completion<JSON>) -> DataRequest? {
        guard let url = URL(string: request.fullPath) else {
            completion(.failure(NSError.init(error: "Invalid Url: \(request.path)", code: -1)))
            return nil
        }
        print(request)
        return  Manager.request(url,
                                method: request.method,
                                parameters: request.parameter,
                                encoding: request.encoding,
                                headers: .init(request.headers ?? [:])).responseJSON { (response) in
                                    completion(map(response))
        }
    }
}
// MARK: - Upload
internal extension ESNetworkManager {
    static func startUpload(files: [MPFile],
                            request: ESNetworkRequest,
                            progress: @escaping ProgressHandler,
                            completion: @escaping Completion<JSON>) -> UploadRequest?{
        guard let url = URL(string: request.fullPath) else {
            completion(.failure(NSError.init(error: "Invalid Url: \(request.path)", code: -1)))
            return nil
        }
        print(request)
       return Manager.upload(multipartFormData: { (multipartFormData) in
            
            for file in files {
                multipartFormData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.memType)
            }
            if let dic = request.parameter {
                for (key, value) in dic {
                    multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, to: url, method: request.method, headers: .init(request.headers ?? [:]) ).responseJSON { (response) in
            completion(map(response))
        }.uploadProgress { (prog) in
            progress(prog.fractionCompleted)
        }
    }
}
// MARK: - Download
internal extension ESNetworkManager {
    static func startDownload(request: ESNetworkRequest,
                              destination: DownloadRequest.Destination?,
                              progress: @escaping ProgressHandler,
                              completion: @escaping Completion<URL>) -> DownloadRequest {
        let destination = destination ?? DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        return Manager.download(
            request.fullPath,
            method: request.method,
            parameters: request.parameter,
            encoding: request.encoding,
            headers: .init(request.headers ?? [:]) ,
            to: destination).downloadProgress(closure: { (prog) in
                progress(prog.fractionCompleted)
            }).response(completionHandler: { (DefaultDownloadResponse) in
                if let url = DefaultDownloadResponse.fileURL {
                    completion(.success(url))
                } else if let downloadError = DefaultDownloadResponse.error {
                    completion(.failure(downloadError))
                } else {
                    completion(.failure(NSError.init(error: "Download failed", code: 0)))
                }
            })
    }
    
    static func resumeDownload(resumingData: Data,
                               destination: DownloadRequest.Destination?,
                               progress: @escaping ProgressHandler,
                               completion: @escaping Completion<URL>) -> DownloadRequest {
        let destination = destination ?? DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        return Manager.download(resumingWith: resumingData, to: destination).downloadProgress(closure: { (prog) in
            progress(prog.fractionCompleted)
        }).response(completionHandler: { (DefaultDownloadResponse) in
            if let url = DefaultDownloadResponse.fileURL {
                completion(.success(url))
            } else if let downloadError = DefaultDownloadResponse.error {
                completion(.failure(downloadError))
            } else {
                completion(.failure(NSError.init(error: "Download failed", code: 0)))
            }
        })
    }
}
