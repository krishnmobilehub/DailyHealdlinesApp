//
//  NewsResponse.swift
//  DailyNews
//

import ObjectMapper

class NewsResponse: Mappable {
    
    var news: [News]!
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        news <- map["articles"]
    }
}
