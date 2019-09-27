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

extension Int {
    
    func penniesToFormattedCurrency() -> String {
        //if the int this functions is being called on is 1234
        //dollars = 1234/100 = $12.34
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}

extension Locale {
    static var current : Locale { return Locale.init(identifier: "en_US") }
}
