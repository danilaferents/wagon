
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
    var favourite: Bool
}
