//
//  Source.swift
//  DailyNews
//


import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

class Source: Mappable {
    var sid: String!
    var name: String!
    var category: String!
    var urlsToLogos: String!
    
    init(sid: String!, name: String!, category: String!, urlsToLogos: String!) {
        self.sid = sid
        self.name = name
        self.category = category
        self.urlsToLogos = urlsToLogos
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        sid <- map["id"]
        name <- map["name"]
        category <- map["category"]
        urlsToLogos <- map["urlsToLogos.medium"]
    }
}
