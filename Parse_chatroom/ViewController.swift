//
//  ViewController.swift
//  Parse_chatroom
//
//  Created by zheng wu on 2/23/17.
//  Copyright © 2017 CodeMonkey. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {

    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var usernameLabel: UITextField!
    @IBAction func onLogin(_ sender: Any) {
        if((passwordLabel.text?.isEmpty)! || (usernameLabel.text?.isEmpty)!){
            view.makeToast(message: "username or password cannot be empty.")
            return
        }
        else{
            let username = usernameLabel.text!
            let password = passwordLabel.text!
            do{
        try PFUser.logIn(withUsername: username, password: password)
            self.performSegue(withIdentifier: "toChat", sender: nil)
        
            }
            catch{
            view.makeToast(message: error.localizedDescription)
            print("error with log in.")
            }
        
            
        
        }
    }
    @IBAction func onSignUp(_ sender: Any) {
        if((passwordLabel.text?.isEmpty)! || (usernameLabel.text?.isEmpty)!){
        view.makeToast(message: "username or password cannot be empty.")
            return
        }
        else{
            
            let user = PFUser()
            user.username = usernameLabel.text!
            user.password = passwordLabel.text!
            
            user.signUpInBackground {
                (succeeded: Bool, error: Error?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                    self.view.makeToast(message: error!.localizedDescription)
                    // Show the errorString somewhere and let the user try again.
                } else {
                    // Hooray! Let them use the app now.
                    self.view.makeToast(message: "Signup successfully...")
                    self.performSegue(withIdentifier: "toChat", sender: nil)
                }
            }
        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

