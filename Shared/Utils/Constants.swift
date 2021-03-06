//
//  Constants.swift
//  wagon
//
//  Created by Danila Ferents on 16/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let Main = "Main"
    static let loginStoryboard = "LoginStoryboard"
}
struct StoryboardID {
    static let loginVC = "loginVC"
    static let forgotVC = "ForgotPasswordVC"
}
struct ImageIdtf {
    static let greenCheck = "green_check"
    static let redCheck = "red_check"
    static let filledStar = "filled_star"
    static let emptyStar = "empty_star"
    static let placeholder = "placeholder"
}
struct AppColors {
    static let Blue = #colorLiteral(red: 0.2914361954, green: 0.3395442367, blue: 0.4364506006, alpha: 1)
    static let Red = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    static let offWhite = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
}
struct Buttons{
    static let Logout = "Logout"
    static let Login = "Login"
}
struct Identifiers {
    static let categoryCell = "CategoryCell"
    static let prodcutCell = "ProductCell"
    static let addToCat = "toAddCategory"
    static let trashCell = "CartItemCell"
    
}
struct Segues {
    static let toProducts = "toProductsVC"
    static let toEditCategory = "toEditCategory"
    static let toAddEditProduct = "toAddEditProduct"
    static let toFavourites = "toFavourites"
}
