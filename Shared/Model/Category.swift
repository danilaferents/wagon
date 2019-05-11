//
//  Category.swift
//  wagon
//
//  Created by Danila Ferents on 28/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imageUrl: String
    var isActive: Bool = true
    var timeStamp: Timestamp
    
    
    init(name: String, id: String, imgUrl: String, isActive: Bool = true, timeStamp: Timestamp) {
        self.name = name
        self.id = id
        self.imageUrl = imgUrl
        self.isActive = isActive
        self.timeStamp = timeStamp
        
    }
    
    init(data: [String : Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    //convert into dictionary
    
    static func modelToData(category: Category) -> [String: Any] {
        let data: [String: Any] = [
            "name": category.name,
            "id": category.id,
            "imgUrl": category.imageUrl,
            "isActive": category.isActive,
            "timeStamp": category.timeStamp
            ]
        return data
    }
}
