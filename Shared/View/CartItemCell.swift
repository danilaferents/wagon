//
//  CartItemCell.swift
//  wagon
//
//  Created by Danila Ferents on 25/09/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import Kingfisher


protocol CartCellDelegate : class {
    func productRemoveFromTrash(product: Product)
}

class CartItemCell: UITableViewCell {

 override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Outlets
    @IBAction func trashBtn(_ sender: Any) {
    }
    @IBOutlet weak var imageOfItem: RoundedImageView!
    @IBOutlet weak var nameProductLbl: UILabel!
    
    var product: Product!
    
    weak var delegate : CartCellDelegate?
    
    func configureCell(product: Product, delegate: CartCellDelegate) {
        
        self.delegate = delegate
        self.product = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        
        if let price = formatter.string(from: product.price as NSNumber) {
            nameProductLbl.text = "\(product.name) \(price)"
        }
        if let url = URL(string: product.imageUrl) {
            imageOfItem.kf.setImage(with: url)
        }
    }
    
    
    @IBAction func removeBtnClicked(_ sender: Any) {
        delegate?.productRemoveFromTrash(product: product)
    }
}
