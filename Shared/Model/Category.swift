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
    var isAactive: Bool = true
    var timeStamp: Timestamp
}
