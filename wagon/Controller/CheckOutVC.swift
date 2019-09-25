//
//  CheckOutVC.swift
//  wagon
//
//  Created by Danila Ferents on 25/09/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit

class CheckOutVC: UIViewController {
    
//Outlets
    @IBOutlet weak var tableView: UITableView!
    //Buttons
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var placeOrderBtn: RoundedButton!
    //Labels
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var feeLbl: UILabel!
    @IBOutlet weak var shippingLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    //Activity Indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.trashCell, bundle: nil), forCellReuseIdentifier: Identifiers.trashCell)
    }
    @IBAction func orderBtnClicked(_ sender: Any) {
    }
    @IBAction func paymentMethodBtnClicked(_ sender: Any) {
    }
    @IBAction func shippingMethodBtnClicked(_ sender: Any) {
    }
    
}

extension CheckOutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.trashCell, for: indexPath) as? CheckOutCell {
            
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product)
                return cell
        }
        return UITableViewCell()
    }
    
    
}

