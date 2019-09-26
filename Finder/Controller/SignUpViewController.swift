//
//  SignUpViewController.swift
//  Finder
//
//  Created by Justin Sian on 02/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // disable sign up button by default
        enableSignUpButton(enabled: false)
        
        // declare delegates
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // observe text fields to enable sign up button when appropriate
        firstNameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        lastNameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // initialize content of error message as an empty string
        errorMessage.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // immediately make fullNameTF first responder
        firstNameTF.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // resign first responder fo all text fields
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    // disable automatic keyboard dismissal
    override var disablesAutomaticKeyboardDismissal: Bool {
        return false
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        // background button to dismiss keyboard
        self.firstNameTF.resignFirstResponder()
        self.lastNameTF.resignFirstResponder()
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        // dismiss back to main screen
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // call handle sign up function
        handleSignUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // enable the sign up button if none of the text fields are empty
    @objc func textFieldChanged(_ target:UITextField) {
        
        // check if form is filled (bool)
        let formFilled = firstNameTF.text != nil && firstNameTF.text != "" && lastNameTF.text != nil && lastNameTF.text != "" && emailTF.text != nil && emailTF.text != "" && passwordTF.text != nil && passwordTF.text != ""
        
        // enable sign up if form is filled
        enableSignUpButton(enabled: formFilled)
    }
    
    // move to other text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        // if return fullName text field, go to email text field
        case firstNameTF:
            firstNameTF.resignFirstResponder()
            lastNameTF.becomeFirstResponder()
        case lastNameTF:
            lastNameTF.resignFirstResponder()
            emailTF.becomeFirstResponder()
            break
        // if return email text field, go to password text field
        case emailTF:
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
            break
        // if return password text field, go call handle sign up function
        case passwordTF:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    // enable or disable the sign up button
    func enableSignUpButton(enabled:Bool) {
        
        // if enabled
        if enabled {
            // if sign up button is enabled
            // set alpha too 100% and set bool isEnabled to true
            signUpButton.alpha = 1.0
            signUpButton.isEnabled = true
        } else {
            // else if sign up button is disabled
            // reduce alpha and set bool isEnabled to false
            signUpButton.alpha = 0.5
            signUpButton.isEnabled = false
        }
    }
    
    // declare handle sign up function
    @objc func handleSignUp() {
        print("Sign Up Tapped!")
        
        // get text from text fields
        guard let firstName = firstNameTF.text else { return }
        guard let lastName = lastNameTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let pass = passwordTF.text else { return }
        
        // create user in firebase
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            // if user is not nil and error is nil
            if error == nil && user != nil {
                
                // print status
                print("User created successfully")
                
//                // post to user database
                let newUser = Database.database().reference().child("users").child(user!.user.uid)
                
//                // update current user information at this location
                newUser.setValue(["firstName": "\(firstName)", "lastName": "\(lastName)", "id": "\(user!.user.uid)","email": "\(email)"])
                
                // resign first responder
                self.firstNameTF.resignFirstResponder()
                self.lastNameTF.resignFirstResponder()
                self.emailTF.resignFirstResponder()
                self.passwordTF.resignFirstResponder()
                
                // switch to success view controller
                Helper.helper.switchToSuccessViewController()
            } else {
                // print error
                print("Error: \(error!.localizedDescription)")
                
                // display error
                self.errorMessage.text = error!.localizedDescription
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
