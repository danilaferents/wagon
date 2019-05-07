
//
//  Product.swift
//  wagon
//
//  Created by Danila Ferents on 03/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category : String
    var price: Double
    var description : String
    var imageUrl: String
    var timeStamp: Timestamp
    var stock: Int
    
    init(data: [String: Any]) {
        name = data["name"] as? String ?? ""
        id = data["id"] as? String ?? ""
        category = data["category"] as? String ?? ""
        price = data["price"] as? Double ?? Double(0)
        description = data["productDescription"] as? String ?? ""
        imageUrl = data["imgUrl"] as? String ?? ""
        timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        stock = data["stock"] as? Int ?? Int(0)
    }
}
