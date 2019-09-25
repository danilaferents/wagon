//
//  CheckOutCell.swift
//  wagon
//
//  Created by Danila Ferents on 25/09/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit

class CheckOutCell: UITableViewCell {

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
    
    
    func configureCell(product: Product) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            nameProductLbl.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl) {
            imageView?.kf.setImage(with: url)
        }
    }
    
    
    @IBAction func removeBtnClicked(_ sender: Any) {
    }
}
