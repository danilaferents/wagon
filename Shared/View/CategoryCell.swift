//
//  CategoryCell.swift
//  wagon
//
//  Created by Danila Ferents on 28/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    //Outlets
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImg.layer.cornerRadius = 5
    }
    
    func configureCell (category: Category)  {
        categoryLbl.text = category.name
        if let url = URL(string: category.imageUrl) {
            categoryImg.kf.setImage(with: url)
        }
        
    }
}
