//
//  PromiseClient.swift
//  SMEH_ENG_MVVM
//
//  Created by Mahmoud Eissa on 1/13/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

#if canImport(PromiseKit)

import PromiseKit
public extension ESNetworkManager {
    
    static func execute<T>(request: ESNetworkRequest,
                           mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper()) -> Promise<T> {
        return .init { (resolver) in
            execute(request: request, mapper: mapper) { (response: ESNetworkResponse<T>) in
                switch response {
                case .success(let value):
                    return resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    static func upload<T>(files: [MPFile] ,
                          request: ESNetworkRequest,
                          mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper(),
                          progress: @escaping ProgressHandler) -> Promise<T> {
        return .init{ resolver in
            upload(files: files, request: request, mapper: mapper, progress: progress) { (response: ESNetworkResponse<T>) in
                switch response {
                case .success(let value):
                    return resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            }}
    }
    
    static func download(request: ESNetworkRequest,
                         progress: @escaping ProgressHandler) -> Promise<URL> {
        return .init { resolver in
            download(request: request, progress: progress) { (response) in
                switch response {
                case .success(let value):
                    return resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            }}
    }
}

// Default Types
public extension ESNetworkManager {
    static func execute<T>(request: ESNetworkRequest) -> Promise<T> where T: Codable {
        return execute(request: request, mapper: CodableNetworkResponseMapper())
    }
    
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Promise<T> where T: Codable {
        return upload(files: files, request: request, mapper: CodableNetworkResponseMapper<T>() ,progress: progress)
    }
    
    static func execute<T>(request: ESNetworkRequest) -> Promise<T> where T: RawRepresentable {
        return execute(request: request, mapper: RawRepresentableNetworkReponseMapper())
    }
    
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Promise<T> where T: RawRepresentable {
        return upload(files: files, request: request, mapper: RawRepresentableNetworkReponseMapper() ,progress: progress)
    }
}
#endif