//
//  ESNetworkManager+Combine.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/8/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import Alamofire
import Combine

@available(iOS 13.0, *)
public extension ESNetworkManager {
    
    static func execute<T>(request: ESNetworkRequest,
                           mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper()) -> AnyPublisher<T, Error> {
        Deferred {
            Future { resolver in
                execute(request: request, mapper: mapper) { (response: ESNetworkResponse<T>) in
                    switch response {
                    case .success(let value):
                        return resolver(.success(value))
                    case .failure(let error):
                        return resolver(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func upload<T>(data: ESUploadData ,
                          request: ESNetworkRequest,
                          mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper(),
                          progress: @escaping ProgressHandler) -> AnyPublisher<T, Error> {
        Deferred {
            Future { resolver in
                upload(data: data, request: request, mapper: mapper, progress: progress) { (response: ESNetworkResponse<T>) in
                    switch response {
                    case .success(let value):
                        return resolver(.success(value))
                    case .failure(let error):
                        return resolver(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func download(request: ESNetworkRequest,
                         destination: DownloadRequest.Destination? = nil,
                         progress: @escaping ProgressHandler) -> AnyPublisher<URL, Error> {
        Deferred {
            Future { resolver in
                download(request: request, destination: destination, progress: progress) { (response) in
                    switch response {
                    case .success(let value):
                        return resolver(.success(value))
                    case .failure(let error):
                        return resolver(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func resumeDownload(resumingData: Data,
                               destination: DownloadRequest.Destination? = nil,
                               progress: @escaping ProgressHandler) -> AnyPublisher<URL, Error> {
        Deferred {
            Future { resolver in
                resumeDownload(data: resumingData, destination: destination, progress: progress) { response in
                    switch response {
                    case .success(let value):
                        return resolver(.success(value))
                    case .failure(let error):
                        return resolver(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// Default Types
@available(iOS 13.0, *)
public extension ESNetworkManager {
    static func execute<T>(request: ESNetworkRequest) -> AnyPublisher<T, Error> where T: Codable {
        return execute(request: request, mapper: CodableNetworkResponseMapper())
    }
    
    static func execute<T>(request: ESNetworkRequest) -> AnyPublisher<T, Error> where T: RawRepresentable {
        return execute(request: request, mapper: RawRepresentableNetworkReponseMapper())
    }
    
    static func execute<T>(request: ESNetworkRequest) -> AnyPublisher<T, Error> where T: Sequence, T.Element: RawRepresentable {
        return execute(request: request, mapper: RawRepresentableArrayNetworkReponseMapper())
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> AnyPublisher<T, Error> where T: Codable {
        return upload(data: data, request: request, mapper: CodableNetworkResponseMapper<T>() ,progress: progress)
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> AnyPublisher<T, Error> where T: RawRepresentable {
        return upload(data: data, request: request, mapper: RawRepresentableNetworkReponseMapper() ,progress: progress)
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> AnyPublisher<T, Error> where T: Sequence, T.Element: RawRepresentable {
        return upload(data: data, request: request, mapper: RawRepresentableArrayNetworkReponseMapper() ,progress: progress)
    }
}
