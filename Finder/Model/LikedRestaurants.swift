//
//  LikedRestaurants.swift
//  Finder
//
//  Created by Justin Sian on 07/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class LikedRestaurants {
    // singelton
    static let likedRestaurants = LikedRestaurants()
    
    var restaurants: [String] = [] // array to hold all liked restaurants
    let userID = Auth.auth().currentUser!.uid // current user id
    var ref: DatabaseReference = Database.database().reference() // database reference
    
    // retreive liked restaurants for data persistance
    func retrieveFromDatabase() {
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.restaurants = value?["restaurants"] as? [String] ?? [] // assign database info to member value restaurants
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // save liked restaurants to the database
    func saveToDatabase() {
        self.ref.child("users").child(userID).child("restaurants").setValue(restaurants)
    }
}
