//
//  AddEditProductsVC.swift
//  wagonadmin
//
//  Created by Danila Ferents on 11/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {

    
    //Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productDescriptTxt: UITextView!
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    
    //Variables
    var selectedCategory: Category!
    var productToEdit: Product?
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_tap:)))
        tap.numberOfTapsRequired = 1
        productImage.isUserInteractionEnabled = true
        productImage.clipsToBounds = true
        productImage.addGestureRecognizer(tap)
        
        //If we are editing
        if let product = productToEdit {
            productNameTxt.text = product.name
            addBtn.setTitle("Save Changes", for: .normal)
            
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .currency
//            productPrice.text = formatter.string(from: product.price as NSNumber)
            productPrice.text = String(product.price)
            productDescriptTxt.text = product.description
            
            if let url = URL(string: product.imageUrl) {
                productImage.contentMode = .scaleAspectFill
                productImage.kf.setImage(with: url)
            }
        }
    }

    @objc func imageTapped(_tap: UIGestureRecognizer) {
        launchImgPicker()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        
        guard let image = productImage.image, let productName = productNameTxt.text, productName.isNotEmpty, let productPrice = productPrice.text, productPrice.isNotEmpty, let price = Double(productPrice), let description = productDescriptTxt.text, description.isNotEmpty else {
            simpleAlert(title: "Error", msg: "You must add necessary informatiom.")
            activityIndicator.stopAnimating()
            return
        }
        
        self.name = productName
        self.productDescription = description
        self.price = price
        
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        let imageRef = Storage.storage().reference().child("productImages/\(productName).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "images/jpg"
        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to put data.")
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to donload Url.")
                }
                
                guard let url = url else {return}
                self.uploadDocument(url: url.absoluteString)
            })
            self.activityIndicator.stopAnimating()
        }
    }
 
    func uploadDocument(url: String) {
        var docRef : DocumentReference!
        
        var product = Product.init(name: name, id: "", category: selectedCategory.id, price: price, description: productDescription, imageUrl: url)
        
        if let productToEdit = productToEdit {
            //Editing
            docRef = Firestore.firestore().collection("Products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            docRef = Firestore.firestore().collection("Products").document()
            product.id = docRef.documentID
        }
        
        //Convert Data into Dictionary
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to setData")
            }
            return
        }
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    
    func handleError(error: Error, msg: String) {
        debugPrint(error)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
}

extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[ .originalImage] as? UIImage else {return}
        
        productImage.contentMode = .scaleAspectFill
        productImage.image = image
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
