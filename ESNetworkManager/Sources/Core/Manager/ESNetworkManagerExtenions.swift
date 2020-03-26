//
//  ESNetworkManager.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 1/22/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//
import Alamofire


public extension ESNetworkManager  {
    
    @discardableResult
     static func execute<T>(request: ESNetworkRequest,
                            mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper(),
                            completion: @escaping Completion<T>) -> DataRequest? {
         return startRequest(request: request) { (response) in
             completion(mapper.map(response, selections: request.selections))
         }
     }
    
     @discardableResult
     static func upload<T>(files: [MPFile],
                           request: ESNetworkRequest,
                           mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper(),
                           progress: @escaping ProgressHandler,
                           completion: @escaping Completion<T>) -> UploadRequest? {
        return  startUpload(files: files, request: request, progress: progress) { (response) in
             completion(mapper.map(response, selections: request.selections))
         }
     }
    
    @discardableResult
    static func download(request: ESNetworkRequest,
                         destination: DownloadRequest.Destination? = nil,
                         progress: @escaping ProgressHandler,
                         completion: @escaping Completion<URL>) -> DownloadRequest {
       return startDownload(request: request, destination: destination, progress: progress, completion: completion)
    }
    
    @discardableResult
    static func resumeDownload(data: Data,
                               destination: DownloadRequest.Destination?,
                               progress: @escaping ProgressHandler,
                               completion: @escaping Completion<URL>) -> DownloadRequest {
        return resumeDownload(resumingData: data, destination: destination, progress: progress, completion: completion)
    }
}

public extension ESNetworkManager {
    @discardableResult
    static func execute<T>(request: ESNetworkRequest,
                           completion: @escaping Completion<T>) -> DataRequest? where T: Codable {
        return execute(request: request, mapper: CodableNetworkResponseMapper(), completion: completion)
    }
    
    @discardableResult
    static func upload<T>(files: [MPFile],
                           request: ESNetworkRequest,
                           progress: @escaping ProgressHandler,
                           completion: @escaping Completion<T>) -> UploadRequest? where T: Codable {
       return upload(files: files, request: request, mapper: CodableNetworkResponseMapper(), progress: progress, completion: completion)
     }
    
    @discardableResult
    static func execute<T>(request: ESNetworkRequest,
                           completion: @escaping Completion<T>) -> DataRequest? where T: RawRepresentable {
        return execute(request: request, mapper: RawRepresentableNetworkReponseMapper(), completion: completion)
    }
    
    @discardableResult
    static func execute<T>(request: ESNetworkRequest,
                           completion: @escaping Completion<T>) -> DataRequest? where T: Sequence, T.Element: RawRepresentable {
        return execute(request: request, mapper: RawRepresentableArrayNetworkReponseMapper(), completion: completion)
        
    }
    
    @discardableResult
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler,
                          completion: @escaping Completion<T>) -> UploadRequest? where T: RawRepresentable {
       return upload(files: files, request: request, mapper: RawRepresentableNetworkReponseMapper(), progress: progress, completion: completion)
    }
    
    @discardableResult
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler,
                          completion: @escaping Completion<T>) -> UploadRequest? where T: Sequence, T.Element: RawRepresentable {
      return upload(files: files, request: request, mapper: RawRepresentableArrayNetworkReponseMapper(), progress: progress, completion: completion)
    }
}
