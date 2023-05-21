//
//  ESNetworkManager+Async.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/8/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import Alamofire

@available(iOS 13.0.0, *)
public extension ESNetworkManager  {
    
    static func execute<T>(request: ESNetworkRequest,
                           mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper()) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            execute(request: request, mapper: mapper) { (response: ESNetworkResponse<T>) in
                switch response {
                case .success(let value):
                    return continuation.resume(returning: value)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func upload<T>(data: ESUploadData ,
                          request: ESNetworkRequest,
                          mapper: ESNetworkResponseMapper<T> = ESNetworkResponseMapper(),
                          progress: @escaping ProgressHandler) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            upload(data: data, request: request, mapper: mapper, progress: progress) { (response: ESNetworkResponse<T>) in
                switch response {
                case .success(let value):
                    return continuation.resume(returning: value)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func download(request: ESNetworkRequest,
                         destination: DownloadRequest.Destination? = nil,
                         progress: @escaping ProgressHandler) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            download(request: request, destination: destination, progress: progress) { (response) in
                switch response {
                case .success(let value):
                    return continuation.resume(returning: value)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func resumeDownload(resumingData: Data,
                               destination: DownloadRequest.Destination? = nil,
                               progress: @escaping ProgressHandler) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            resumeDownload(data: resumingData, destination: destination, progress: progress) { response in
                switch response {
                case .success(let value):
                    return continuation.resume(returning: value)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
}

@available(iOS 13.0.0, *)
public extension ESNetworkManager {
    
    static func execute<T>(request: ESNetworkRequest) async throws -> T where T: Codable {
        return try await execute(request: request, mapper: CodableNetworkResponseMapper())
    }
    
    static func execute<T>(request: ESNetworkRequest) async throws -> T where T: RawRepresentable {
        return try await execute(request: request, mapper: RawRepresentableNetworkReponseMapper())
    }
    
    static func execute<T>(request: ESNetworkRequest) async throws -> T where T: Sequence, T.Element: RawRepresentable {
        return try await execute(request: request, mapper: RawRepresentableArrayNetworkReponseMapper())
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) async throws -> T where T: Codable {
        return try await upload(data: data, request: request, mapper: CodableNetworkResponseMapper(), progress: progress)
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) async throws -> T where T: RawRepresentable {
        return try await upload(data: data, request: request, mapper: RawRepresentableNetworkReponseMapper(), progress: progress)
    }
    
    static func upload<T>(data: ESUploadData,
                          request: ESNetworkRequest,
                          progress: @escaping ProgressHandler) async throws -> T where T: Sequence, T.Element: RawRepresentable {
        return try await upload(data: data, request: request, mapper: RawRepresentableArrayNetworkReponseMapper(), progress: progress)
    }
}
