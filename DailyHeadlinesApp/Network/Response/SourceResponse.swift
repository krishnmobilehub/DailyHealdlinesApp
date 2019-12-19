//
//  SourceResponse.swift
// DailyHeadlinesApp
//

import ObjectMapper

class SourceResponse: Mappable {
    
    var source: [Source]!
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        source <- map["sources"]
    }
}
