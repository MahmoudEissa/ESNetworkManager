//
//  RxClient.swift
//  SMEH_ENG_MVVM
//
//  Created by Mahmoud Eissa on 1/13/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


#if canImport(RxSwift)

import RxSwift
public extension ESNetworkManager {
    static func execute<T>(request: ESNetworkRequest,
                           mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper<T>()) -> Single<T> {
        return .create { observer in
            execute(request: request, mapper: mapper) { (response: ESNetworkResponse<T>) in
                switch response {
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper<T>(),
                          progress: @escaping ProgressHandler) -> Single<T> {
        return .create { observer in
            upload(files: files, request: request, mapper: mapper, progress: progress) { (response: ESNetworkResponse<T>) in
                switch response {
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    static func download(request: ESNetworkRequest, progress: @escaping ProgressHandler) -> Single<URL> {
        return .create { observer in
            download(request: request, progress: progress) { (response) in
                switch response {
                case .success(let url):
                    observer(.success(url))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

// Default Types
public extension ESNetworkManager {
    static func execute<T>(request: ESNetworkRequest) -> Single<T> where T: Codable {
        return execute(request: request, mapper: CodableNetworkResponseMapper())
    }
    
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Single<T> where T: Codable {
        return upload(files: files, request: request, mapper: CodableNetworkResponseMapper() ,progress: progress)
    }
    
    static func execute<T>(request: ESNetworkRequest) -> Single<T> where T: RawRepresentable {
        return execute(request: request, mapper: RawRepresentableNetworkReponseMapper())
    }
    
    static func upload<T>(files: [MPFile],
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Single<T> where T: RawRepresentable {
        return upload(files: files, request: request, mapper: RawRepresentableNetworkReponseMapper() ,progress: progress)
    }
}
#endif
