//
//  News.swift
//  DailyNews
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

class News: Mappable {
    var title: String!
    var author: String!
    var publishedAt: String!
    var urlToImage: String!
    var description: String!
    var url: String!
    
    init(title: String!, author: String!, publishedAt: String!, urlToImage: String!, description: String!, url: String!) {
        self.title = title
        self.author = author
        self.publishedAt = publishedAt
        self.urlToImage = urlToImage
        self.description = description
        self.url = url
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        author <- map["author"]
        publishedAt <- map["publishedAt"]
        urlToImage <- map["urlToImage"]
        description <- map["description"]
        url <- map["url"]
    }
}
