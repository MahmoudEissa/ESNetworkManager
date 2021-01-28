//
//  ESNetworkManager+ObjectMapper.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/24/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

import Alamofire

#if canImport(ObjectMapper)
import ObjectMapper
public extension ESNetworkManager {
    @discardableResult
    static func execute<T>(request: ESNetworkRequest,
                           completion: @escaping Completion<T>) -> DataRequest? where T: Mappable {
        return execute(request: request, mapper: MappableNetworkReponseMapper(), completion: completion)
    }
    
    @discardableResult
    static func execute<T>(request: ESNetworkRequest,
                           completion: @escaping Completion<T>) -> DataRequest? where T: Sequence, T.Element: Mappable {
        return execute(request: request, mapper: MappableArrayNetworkReponseMapper(), completion: completion)
        
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler,
                          completion: @escaping Completion<T>) where T: Mappable {
        upload(data: data, request: request, mapper: MappableNetworkReponseMapper(), progress: progress, completion: completion)
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler,
                          completion: @escaping Completion<T>) where T: Sequence, T.Element: Mappable {
        upload(data: data, request: request, mapper: MappableArrayNetworkReponseMapper(), progress: progress, completion: completion)
    }
}

#if canImport(PromiseKit)
import PromiseKit
public extension ESNetworkManager {
    static func execute<T>(request: ESNetworkRequest) -> Promise<T> where T: Mappable {
        return execute(request: request, mapper: MappableNetworkReponseMapper())
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Promise<T> where T: Mappable {
        return upload(data: data, request: request, mapper: MappableNetworkReponseMapper<T>() ,progress: progress)
    }
    
    static func execute<T>(request: ESNetworkRequest) -> Promise<T> where T: Sequence, T.Element: Mappable {
        return execute(request: request, mapper: MappableArrayNetworkReponseMapper())
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Promise<T> where T: Sequence, T.Element: Mappable {
        return upload(data: data, request: request, mapper: MappableArrayNetworkReponseMapper() ,progress: progress)
    }
}
#endif

#if canImport(RxSwift)
import RxSwift
public extension ESNetworkManager {
    static func execute<T>(request: ESNetworkRequest) -> Single<T> where T: Mappable {
        return execute(request: request, mapper: MappableNetworkReponseMapper())
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Single<T> where T: Mappable {
        return upload(data: data, request: request, mapper: MappableNetworkReponseMapper<T>() ,progress: progress)
    }
    
    static func execute<T>(request: ESNetworkRequest) -> Single<T> where T: Sequence, T.Element: Mappable {
        return execute(request: request, mapper: MappableArrayNetworkReponseMapper())
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) -> Single<T> where T: Sequence, T.Element: Mappable {
        return upload(data: data, request: request, mapper: MappableArrayNetworkReponseMapper() ,progress: progress)
    }
}
#endif

#endif

