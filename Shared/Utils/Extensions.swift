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
    func handleFireError(error: Error) {
        //Customise errors in Auth in Firebase
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            //Initialise alert which will appear in the middle[because of style .alert] of the screen with title "Error", localised description of it.
//            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            //with custom error
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            //An action to Ok button
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            //Add action to alert
            alert.addAction(okAction)
            //present an alert
            present(alert, animated: true, completion: nil)
            
        }
    }
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension AuthErrorCode {
    //need to renew knowledge about initialisinh variable right after building
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The mail is alreadi in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check information and try again."
        case .userDisabled:
            return ""
        case .wrongPassword:
            return "Input password is incorrect."
        case .weakPassword:
            return "Input password is too weak. The password must be 6 characters or more."
        case .networkError:
            return "Oops. Network error. Please try again."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email."
        default:
            return "Sorry, something went wrong."
        }
    }
}

