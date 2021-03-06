//
//  ProductCell.swift
//  wagon
//
//  Created by Danila Ferents on 03/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
//for imageUrl
import Kingfisher

protocol ProductCellDelegate : class {
    func productFavourited(product: Product)
    func productAdd(product: Product)
}


class ProductCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTtl: UILabel!
    @IBOutlet weak var productPrc: UILabel!
    @IBOutlet weak var productBtn: RoundedButton!
    @IBOutlet weak var favBtn: UIButton!
    
    weak var delegate : ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(product: Product, delegate: ProductCellDelegate){
        //Set  delegates
        self.product = product
        self.delegate = delegate
        
        productTtl.text = product.name
        productPrc.text = String(product.price)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrc.text = price
        }
        
        //set Image
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: ImageIdtf.placeholder)
            productImg.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
//            productImg.kf.setImage(with: url)
        }
        //Compare favourites and selectedProduct to be favourite
        if userService.favourites.contains(product) {
            //change image from empty star to full star
            favBtn.setImage(UIImage(named: ImageIdtf.filledStar), for: .normal)
        } else {
            //make image from empty star
            favBtn.setImage(UIImage(named: ImageIdtf.emptyStar), for: .normal)
        }
    }
    
    @IBAction func addtocardClicked(_ sender: Any) {
        //Delegate adding to cart to ProductsVC
        delegate?.productAdd(product: product)
    }
    @IBAction func favouriteClicked(_ sender: Any) {
        //delegate saving favourite to Products
        delegate?.productFavourited(product: product)
    }
    
}
