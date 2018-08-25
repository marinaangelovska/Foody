//
//  ViewController.swift
//  Foody
//
//  Created by Marina Angelovska on 4/30/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        signInUser()
    }
    
    func signInUser() {
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.showError(message: (error?.localizedDescription)!)
            } else {
                self.rememberUser()
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        })
    }
    func rememberUser() {
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(self.usernameTextField.text!, forKey: "Username")
        prefs.set(1, forKey: "isUserLoggedIn")
        prefs.synchronize()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

