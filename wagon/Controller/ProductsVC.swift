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
    var db : Firestore!
    var listener : ListenerRegistration!
    var showFavourites = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setTableView()
        
    }
    
    func setTableView() {
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: Identifiers.prodcutCell, bundle: nil), forCellReuseIdentifier: Identifiers.prodcutCell)
    }
    override func viewDidAppear(_ animated: Bool) {
        setProductsListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        products.removeAll()
        tableView.reloadData()
    }
    
    func setProductsListener() {
        
        var ref: Query!
        
        if showFavourites {
            ref = db.collection("Users").document(userService.user.id).collection("Favourites")
        } else {
            ref = db.products(category: getCategory.id)
        }
        
        //whereField make search by field category(equal to getCategory which we get from segue)
        listener = ref.addSnapshotListener({ (query, error ) in
            if let error = error {
                debugPrint(error)
                return
            }
            query?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch (change.type) {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                @unknown default:
                    print("Unknown cahange in TableView!")
                }
            })
        })
    }
}

extension ProductsVC:  ProductCellDelegate {
    
    //Function to conform protocol
    func productFavourited(product: Product) {
        userService.favouriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else {return}
        //To Call Configure Cell in cellfoRowat
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    //Function to conform protocol
    func productAdd(product: Product) {
        StripeCart.addItemToCart(item: product)
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
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell;
        }
        return UITableViewCell()
        }
        //Set height for Row
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = ProductDetailVCViewController()
            let selectedProduct = products[indexPath.row]
            //Give our "pizza" to another vc
            vc.product = selectedProduct
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
        }
        
        func onDocumentAdded(change: DocumentChange, product: Product) {
            //We have only new index
            let newIndex = Int(change.newIndex)
            products.insert(product, at: newIndex)
            tableView.insertRows(at: [IndexPath(item: newIndex, section: 0 )], with: .fade)
        }
        
        func onDocumentModified(change : DocumentChange, product: Product)  {
            //       Item changed, but remained in the same position
            if change.oldIndex == change.newIndex {
                let index = Int(change.oldIndex)
                products[index] = product
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            } else {
                //Item changed position
                let oldIndex = Int(change.oldIndex)
                let newIndex = Int(change.newIndex)
                products.remove(at: oldIndex)
                products.insert(product, at: newIndex)
                
                tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
            }
        }
        func onDocumentRemoved(change: DocumentChange) {
            //We have only old index
            products.remove(at: Int(change.oldIndex))
            tableView.deleteRows(at: [IndexPath(row: (Int(change.oldIndex)), section: 0)] , with: .fade)
        }
        
        
}
