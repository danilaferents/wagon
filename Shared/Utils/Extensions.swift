//
//  Extensions.swift
//  wagon
//
//  Created by Мой Господин on 14/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//variable to make cod more readable
extension String {
    var isNotEmpty : Bool{
        return !isEmpty
    }
}
//extension to make function to error handling
extension UIViewController {
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

