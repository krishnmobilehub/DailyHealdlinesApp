//
// DailyNewsHttpRouter.swift
// DailyHeadlinesApp
//

import Foundation
import Alamofire
import ObjectMapper

let baseURL = "https://newsapi.org/"
let apiToken = "53b8c0ba0ea24a199f790d660b73675f"

enum DailyNewsHttpRouter: URLRequestConvertible {
    
    case news(source: String)
    case source(category: String)
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var version: String {
        return "v1"
    }
    
    var path: String {
        switch self {
        case .news:
             return "articles"
        case .source:
            return "sources"
        }
    }
    
    var jsonParameters: [String: Any]? {
        return nil
    }
    
    var urlParameters: [String: Any]? {
        switch self {
        case .news (let source):
            return [
                "source" : source,
                "apiKey": apiToken
            ]
        case .source (let category):
            let language = "en"
            return [
                "category" : category,
                "language" : language
            ]
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest{
        let url = NSURL(string: baseURL)!
        let versionedUrl = url.appendingPathComponent(self.version)!
        var urlRequest = URLRequest(url: versionedUrl.appendingPathComponent(self.path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("en", forHTTPHeaderField: "Accept-Language")
        
        switch self {
        case .news,
             .source:
            return try URLEncoding.queryString.encode(
                urlRequest,
                with: self.urlParameters)
        }
    }
}
