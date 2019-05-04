//
//  ProductsVCViewController.swift
//  wagon
//
//  Created by Danila Ferents on 03/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var products = [Product]()
    var getCategory: Category!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product.init(name: "Landscape", id: "fae", category: "Nature", price: 33.33, description: "Very good", imageUrl: "https://images.unsplash.com/photo-1553531384-411a247ccd73?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80", timeStamp: Timestamp(), stock: 0, favourite: false)
        products.append(product)
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: Identifiers.prodcutCell, bundle: nil), forCellReuseIdentifier: Identifiers.prodcutCell)
    }
}
    //Set number of rows
    extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return products.count
        }
    //Get Cell from Table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.prodcutCell, for: indexPath) as? ProductCell{
            cell.configureCell(product: products[indexPath.row])
            return cell;
        }
        return UITableViewCell()
    }
    //Set height for Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
