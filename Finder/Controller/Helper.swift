//
//  Helper.swift
//  Finder
//
//  Created by Justin Sian on 03/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class Helper {
    static let helper = Helper()
    // switch to success view
    func switchToSuccessViewController() {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main storyboard, instantiate success view
        let successVC = storyboard.instantiateViewController(withIdentifier: "MainAppVC")
        
        // get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // set the success view controller as root view controller
        appDelegate.window?.rootViewController = successVC
    }
    
    // log out function
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        
        // switch to loginViewController
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main storyboard, instantiate success view
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC")
        
        // get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // set the success view controller as root view controller
        appDelegate.window?.rootViewController = logInVC
    }
}
