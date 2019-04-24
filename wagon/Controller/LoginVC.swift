//
//  LoginVC.swift
//  wagon
//
//  Created by Мой Господин on 11/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var loginBtn: RoundedButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        
    }
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error.", msg: "Please fill out all fields.")
                return
                
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in if let error = error {
                self.handleFireError(error: error)
                debugPrint(error.localizedDescription)
            self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        
    }
}
