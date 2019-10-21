//
//  NetworkManager.swift
//  DailyNews
//

import Foundation

import BrightFutures
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

enum NetworkError: Error {
    case notFound
    case unauthorized
    case forbidden
    case nonRecoverable
    case unprocessableEntity(String?)
    case other
}

struct NetworkManager {
    
    // networking queue
    static let networkQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "").networking-queue", attributes: .concurrent)
    
    static func makeRequest<T: Mappable>(_ urlRequest: URLRequestConvertible) -> Future<T, NetworkError> {
        let promise = Promise<T, NetworkError>()
        let request = AF.request(urlRequest)
            .validate()
            .responseObject(queue: networkQueue) { (response: DataResponse<T>) in
                switch response.result {
                case .success:
                    promise.success(response.result.value!)
                case .failure
                    where response.response?.statusCode == 401:
                    promise.failure(.unauthorized)
                case .failure
                    where response.response?.statusCode == 403:
                    promise.failure(.unauthorized)
                case .failure
                    where response.response?.statusCode == 404:
                    promise.failure(.notFound)
                case .failure
                    where response.response?.statusCode == 422:
                    var jsonData: String?
                    if let data = response.data {
                        jsonData = String(data: data, encoding: .utf8)
                    }
                    promise.failure(.unprocessableEntity(jsonData))
                case .failure
                    where response.response?.statusCode == 500:
                    promise.failure(.nonRecoverable)
                case .failure:
                    promise.failure(.other)
                }
        }
        
        debugPrint(request)
        
        return promise.future
    }
}
