//
//  RegisterViewController.swift
//  Foody
//
//  Created by Marina Angelovska on 4/30/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class RegisterViewController: UIViewController, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert])
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if (passwordTextField.text! == repeatPasswordTextField.text!) {
            FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("registration successful")
                    self.loginUser()
                }
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Passwords must match!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loginUser() {
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.showError(message: (error?.localizedDescription)!)
            } else {
                self.rememberUser()
                self.performSegue(withIdentifier: "goToHome2", sender: self)
                self.notificationShow()
            }
        })
    }
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func rememberUser() {
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(self.usernameTextField.text!, forKey: "Username")
        prefs.set(1, forKey: "isUserLoggedIn")
        prefs.synchronize()
    }
    func notificationShow() {
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = "Welcome to Foody!"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Welcome", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
