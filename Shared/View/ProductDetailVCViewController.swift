//
//  ProductDetailVCViewController.swift
//  wagon
//
//  Created by Danila Ferents on 07/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit

class ProductDetailVCViewController: UIViewController {

    //Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTtl: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescr: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTtl.text = product.name
        product.description = product.description
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        //When we tap outside Product Description than we dismiss it
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        //Add product to card
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func keepClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
