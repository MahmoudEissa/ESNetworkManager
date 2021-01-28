
//  Created by Mahmoud Eissa on 12/14/17.
//  Copyright © 2017 Asgatech. All rights reserved.

import Alamofire

public typealias ProgressHandler = (_ progress: Progress) -> Void
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
                                parameters: request.parameters,
                                encoding: request.encoding,
                                headers: .init(request.headers ?? [:])).responseJSON { (response) in
                                    completion(map(response))
        }
    }
}
// MARK: - Upload
public enum ESUploadData {
    case date(Data)
    case stream(InputStream)
    case multipart([MPFile])
}

internal extension ESNetworkManager {
    static func startUpload(data: ESUploadData,
                            request: ESNetworkRequest,
                            progress: @escaping ProgressHandler,
                            completion: @escaping Completion<JSON>) -> UploadRequest?{
        guard URL(string: request.fullPath) != nil else {
            completion(.failure(NSError.init(error: "Invalid Url: \(request.path)", code: -1)))
            return nil
        }
        print(request)
        let task: UploadRequest?
        switch data {
        case .date(let data):
            task = upload(data, request: request)
            
        case .stream(let stream):
            task = upload(stream, request: request)
            
        case .multipart(let files):
            task = upload(files, request: request)
        }
        return task?.responseJSON { completion(map($0)) }.uploadProgress { progress($0) }
    }
    
    private static func upload(_ data: Data, request: ESNetworkRequest) -> UploadRequest?{
        return Manager.upload(data,
                              to: URL(string: request.fullPath)!,
                              method: request.method,
                              headers: .init(request.headers ?? [:]))
    }
    
    private static func upload(_ stream: InputStream, request: ESNetworkRequest) -> UploadRequest?{
        return Manager.upload(stream,
                              to: URL(string: request.fullPath)!,
                              method: request.method,
                              headers: .init(request.headers ?? [:]))
    }
    
    private static func upload(_ files: [MPFile], request: ESNetworkRequest) -> UploadRequest?{
        return Manager.upload(multipartFormData: { (multipartFormData) in
            for file in files {
                multipartFormData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.memType)
            }
            if let dic = request.parameters {
                for (key, value) in dic {
                    multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        },
        to: URL(string: request.fullPath)!,
        method: request.method,
        headers: .init(request.headers ?? [:]) )
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
            parameters: request.parameters,
            encoding: request.encoding,
            headers: .init(request.headers ?? [:]) ,
            to: destination).downloadProgress(closure: { (prog) in
                progress(prog)
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
        return Manager.download(resumingWith: resumingData, to: destination).downloadProgress(closure: { (prog) in
            progress(prog)
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

