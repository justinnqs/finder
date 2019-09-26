//
//  LogInViewController.swift
//  Finder
//
//  Created by Justin Sian on 03/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init login button enabled to false
        enableLogInButton(enabled: false)
        
        // declare delegates
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // observe text fields to enable log in button when appropriate
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // initialize content of error message as an empty string
        errorMessageLabel.text = ""
    }
    
    // view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
        Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in

            // if authenticated
            if user != nil {
                // print message
                print("User is already logged in")
                // automatically switch to chat view
                Helper.helper.switchToSuccessViewController()
            } else {
                print("Not logged in.")
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // resign first responder fo all text fields
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        // background button to dismiss keyboard
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    
    @IBAction func redirectToSignUp(_ sender: Any) {
        // redirect to signup page when button clicked
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @IBAction func loginWithPasswordTapped(_ sender: Any) {
        handleSignIn()
        
        // dismiss keyboard
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // enable the log in button if none of the text fields are empty
    @objc func textFieldChanged(_ target:UITextField) {
        
        // check if form is filled (bool)
        let formFilled = emailTF.text != nil && emailTF.text != "" && passwordTF.text != nil && passwordTF.text != ""
        
        // enable sign up if form is filled
        enableLogInButton(enabled: formFilled)
    }
    
    // move to other text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        // if return email text field, go to email text field
        case emailTF:
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
            break
        // if return password text field, go call handle sign up function
        case passwordTF:
            handleSignIn()
            break
        default:
            break
        }
        return true
    }

    func enableLogInButton(enabled: Bool) {
        if enabled {
            logInButton.alpha = 1.0
            logInButton.isEnabled = true
        } else {
            logInButton.alpha = 0.5
            logInButton.isEnabled = false
        }
    }
    
    @objc func handleSignIn() {
        print("Log In Tapped!")
        
        // get the text from text fields (if any)
        guard let email = emailTF.text else { return }
        guard let pass = passwordTF.text else { return }
        
        // log in with password
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            // if login is not successful (error != nil)
            if error != nil {
                // print error
                print(error!.localizedDescription)
                
                // display error
                self.errorMessageLabel.text = error!.localizedDescription
                // return
                return
            } else {
                // switch to success view
                Helper.helper.switchToSuccessViewController()
                LikedRestaurants.likedRestaurants.retrieveFromDatabase()
            }
        }
    }
}
