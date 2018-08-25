//
//  LogOutViewController.swift
//  Foody
//
//  Created by Marina Angelovska on 5/2/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import UIKit
import Firebase

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        signOutUser()
    }
    
    func signOutUser() {
        do {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "logout", sender: self)
            forgetUser()
            
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        } catch {
            print("Unknown error.")
        }
    }
    func forgetUser() {
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set("", forKey: "Username")
        prefs.set(0, forKey: "isUserLoggedIn")
        prefs.synchronize()
    }
    
}
