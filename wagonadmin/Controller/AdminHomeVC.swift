//
//  ViewController.swift
//  wagonadmin
//
//  Created by Мой Господин on 07/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        
        navigationItem.rightBarButtonItem = addCategoryBtn
    }
    
    @objc func addCategory() {
        //segue to add category view
        performSegue(withIdentifier: Identifiers.addToCat, sender: self)
    }

}

