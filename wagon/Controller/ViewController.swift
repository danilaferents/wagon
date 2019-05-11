//
//  ViewController.swift
//  wagon
//
//  Created by Мой Господин on 07/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //redirect ViewController to LoginVC
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: Storyboard.loginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.loginVC)
        present(controller, animated: true, completion: nil)
    }

}

