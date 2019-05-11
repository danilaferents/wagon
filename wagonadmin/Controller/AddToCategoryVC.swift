//
//  AddToCategoryVC.swift
//  wagonadmin
//
//  Created by Danila Ferents on 10/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddToCategoryVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
    
    //Variables
    var categoryToEdit: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        //If we are editing categoryToEdit will be not nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            if let url = URL(string: category.imageUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        //launch the img picker
        launchImgPicker()
        
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    //Upload Image
    func uploadImageThenDocument() {
        
        guard let image = categoryImg.image,  let categoryName = nameTxt.text, categoryName.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Must add category image and name")
            activityIndicator.stopAnimating()
            return
        }
        
        activityIndicator.startAnimating()
        
        //Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        //Create an storage image reference -> A location in Furestorage for it to be stored
        let imageRef = Storage.storage().reference().child("categoryImages/\(categoryName).jpg")
        //Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to put data into reference")
                return
            }
            
            //Once the image is uploaded, retrieve (извлекать) the download URL
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                   self.handleError(error: error, msg: "Unable to donloadUrl")
                    return
                }
                guard let url = url else {return}
                //Upload new Category to the Firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            })
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        //force wrap because we have checked emptiness of nameTxt before
        
        //set category
        var category = Category.init(name: nameTxt.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            //We are editing
                docRef = Firestore.firestore().collection("Categories").document(categoryToEdit.id)
                category.id = categoryToEdit.id
        } else {
            //New Category
                //get reference where it will be stored
                docRef = Firestore.firestore().collection("Categories").document()
                //set id of category
                category.id = docRef.documentID
        }
        //convert category into dictionary
        let data = Category.modelToData(category: category)
        //setData into storage
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new category to Firestore!")
                return
            }
            //return back
            self.navigationController?.popViewController(animated: true)
        }
    }
    func handleError(error: Error, msg: String) {
            debugPrint(error)
            self.simpleAlert(title: "Error", msg: msg)
            self.activityIndicator.stopAnimating()
    }
}

extension AddToCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
       present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[ .originalImage] as? UIImage else {return}
        //Change the center whick is used for camera in View Controller to Aspect Fill
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
