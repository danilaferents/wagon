//
//  UserService.swift
//  wagon
//
//  Created by Danila Ferents on 13/05/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

let userService = _UserService()

final class _UserService {
    
    //Variables
    var user = User()
    var favourites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var favsListener : ListenerRegistration? = nil
    
    var isGuest : Bool {
        
        guard let authUser = auth.currentUser else {
            return true
        }
        
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    func getCurrentUser() {
        guard let authUser = auth.currentUser else {return}
        //Maybe better:
//        if isGuest {
//            return
//        }
        //Add Listener to Users
        let userRef = db.collection("Users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else {return}
//            print(data)
            //Remember user
            self.user = User.init(data: data)
        })
        
        //Add Listener to Favourites
        let favsRef = userRef.collection("Favourites")
        favsListener = favsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documents.forEach({ (document) in
                let favourite = Product.init(data: document.data())
                self.favourites.append(favourite)
            })
        })
    }

    func favouriteSelected(product: Product) {
        let favRef = db.collection("Users").document(user.id).collection("Favourites")
        
        if favourites.contains(product) {
            //We remove a favourite
            favourites.removeAll { $0 == product}
            favRef.document(product.id).delete()
        } else {
            //Add a favourite
            favourites.append(product)
            let data = Product.modelToData(product: product)
            favRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = User()
        favourites.removeAll()
    }
    
}
