//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Zhaoya Sun on 12/2/17.
//  Copyright © 2017 Zhaoya Sun. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: UIButton) {
       registerUser()
    }
    
    @IBAction func login(_ sender: UIButton) {
        loginUser()
    }
    
    func registerUser() {
       view.isUserInteractionEnabled = false
        SVProgressHUD.show()
        guard let username = usernameLabel.text, !username.isEmpty else {
            ErrorAlert(error: "Email is empty.")
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            return
        }
        
        guard let password = passwordLabel.text, !password.isEmpty else {
           ErrorAlert(error: "Password is empty")
            view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            return
        }
        
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        
        newUser.signUpInBackground { (successful, error) in
            if let error = error {
                print(error.localizedDescription)
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
            } else if successful {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
            }
        }
    
    }
    
    func loginUser() {
        guard let username = usernameLabel.text, !username.isEmpty else {
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            return
        }
        
        guard let password = passwordLabel.text, !password.isEmpty else {
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            return
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                self.ErrorAlert(error: "Login failed")
                print("User log in failed: \(error.localizedDescription)")
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("User logged in successfully")
                
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                // display view controller that needs to shown after successful login
            }
        }
    }
    
    func ErrorAlert(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

