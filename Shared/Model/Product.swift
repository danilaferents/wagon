
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
    
    
    init(name: String, id: String, category: String, price: Double, description: String, imageUrl: String, timestamp: Timestamp = Timestamp(), stock: Int = 0) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.description = description
        self.imageUrl = imageUrl
        self.timeStamp = timestamp
        self.stock = stock
    }
    
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
    
    
    static func modelToData(product: Product)-> [String: Any] {
        let data = [
            "category": product.category,
            "id": product.id,
            "imgUrl": product.imageUrl,
            "name": product.name,
            "price": product.price,
            "productDescription": product.description,
            "stock": product.stock,
            "timeStamp": product.timeStamp
            ] as [String : Any]
        return data
    }
}

extension Product : Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
