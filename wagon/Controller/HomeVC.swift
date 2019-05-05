//
//  ViewController.swift
//  wagon
//
//  Created by Мой Господин on 07/04/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var categories = [Category]()
    var selectedCat: Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    //If we do not have user logged in so we will sign in anonymous account
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //what type of view to display
        collectionView.register(UINib(nibName: Identifiers.categoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.categoryCell)
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously{(result, error) in
                if let error = error {
                    debugPrint(error);
                    Auth.auth().handleFireError(error: error, vc: self)
                }
            }
        }
//        fetchCollection()
    }
    
    
    //If we have user(not anonymous) then we need to modify button to "Logout"
    override func viewDidAppear(_ animated: Bool) {
        setCategoriesListener()
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            //We are loggen in
            loginOutBtn.title = Buttons.Logout
        } else {
            loginOutBtn.title = Buttons.Login
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    
    
    func setCategoriesListener() {
        listener = db.collection("Categories").addSnapshotListener({ (query, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            query?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch (change.type) {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified()
                case .removed:
                    self.onDocumentRemoved()
                }
            })
        })
    }
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified()  {
        
    }
    
    func onDocumentRemoved() {
        
    }
    
    //Fetch Multiple documents
    func fetchCollection()
    {
        let collectionReference = db.collection("Categories")
        
        listener = collectionReference.addSnapshotListener { (query, error) in
            guard let documents = query?.documents else {return}
            
             query?.documentChanges.count
            
            self.categories.removeAll()
            for document in documents {
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        }
        
//        collectionReference.getDocuments { (query, error) in
//            guard let documents = query?.documents else {return}
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {return}
        if user.isAnonymous {
            //Present login Storyboard
            presentLoginController();
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleFireError(error: error, vc: self)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error)
                Auth.auth().handleFireError(error: error, vc: self)
            }
        }
//        if let _ = Auth.auth().currentUser {
//            //We are loggen in
//            do {
////                try Auth.auth().signOut()
//                presentLoginController()
//            } catch {
//                debugPrint(error.localizedDescription)
//            }
//        } else {
//                presentLoginController()
//            }
    }
    
    
    //redirect ViewController to LoginVC
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.loginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.loginVC)
        present(controller, animated: true, completion: nil)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.categoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHieght = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHieght)
    }
    //Perfrom Segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCat = categories[indexPath.item]
        
        performSegue(withIdentifier: Segues.toProducts, sender: self)
    }
    //to give selectedCategory to variable on the orher VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == Segues.toProducts {
            if let dest = segue.destination as? ProductsVC {
                dest.getCategory = selectedCat
            }
        }
    }
}


//Remember code :)
//Fetch data from database only for one doc
//    func fetchDoc() {
//        //Get Snap
//        let docRef = db.collection("Categories").document("kDSmR2gZQeGfKCBZdVYb")
//
//        //Fetch in real time
//        docRef.addSnapshotListener { (snap, error) in
//            self.categories.removeAll()
//            guard let data = snap?.data() else {return}
//            //Make new Category
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            //Reload Data in CollectionView
//            self.collectionView.reloadData()        }

//        docRef.getDocument { (snap, error) in
//            guard let data = snap?.data() else {return}
//            //Make new Category
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            //Reload Data in CollectionView
//            self.collectionView.reloadData()
//        }
//    }
