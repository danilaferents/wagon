//
//  AdminProductsVC.swift
//  wagonadmin
//
//  Created by Danila Ferents on 11/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {

    var selectedProduct : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add Buttons in code
        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        
        navigationItem.setRightBarButtonItems([editCategoryBtn, newProductBtn], animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Issue when i return back to this VC I run into issue that i already have selectedProduct
        selectedProduct = nil
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.toEditCategory, sender: self)
    }
    
    @objc func newProduct() {
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Editing product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = getCategory
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.toEditCategory {
                if let destination = segue.destination as? AddToCategoryVC {
                    destination.categoryToEdit = getCategory
                }
        }
    }
}
