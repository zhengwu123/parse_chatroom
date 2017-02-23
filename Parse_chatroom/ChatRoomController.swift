//
//  ChatRoomController.swift
//  Parse_chatroom
//
//  Created by zheng wu on 2/23/17.
//  Copyright © 2017 CodeMonkey. All rights reserved.
//

import UIKit
import Parse

class ChatRoomController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var messages: [PFObject] = []
    @IBOutlet var tableview: UITableView!

    @IBAction func onSend(_ sender: Any) {
        if(msgText.text?.isEmpty)!{
            view.makeToast(message: "message field cannot be empty!")
            return
        }
        else{
            let message = PFObject(className:"chatMessages")
            message["content"] = msgText.text
            message["username"] = PFUser.current()?.username
            message.saveInBackground { (saved:Bool, error:Error?) -> Void in
                if saved {
                    self.msgText.text = ""
                    print("saved worked")
                } else {
                    print(error!)
                }
            }
        }
    }
    @IBOutlet var msgText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        
    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ChatRoomController.onTimer), userInfo: nil, repeats: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count != 0 {
        return messages.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCellTableViewCell
        let message =  messages[indexPath.row]
        cell.messageLabel.text = message["content"] as! String?
        if(message["username"] != nil){
        cell.usernameLabel.text = message["username"] as! String?
        }
        
        return cell
    }
    
    func onTimer() {
        // Add code to be run periodically
        
        let query = PFQuery(className:"chatMessages")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    self.messages = objects
                }
            } else {
                // Log details of the failure
                print("error with finding ojbect.")
            }
        }
        tableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLogout(_ sender: Any) {
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            // Do stuff with the user
            print("Logout clicked.")
            PFUser.logOut()
            self.performSegue(withIdentifier: "toMain", sender: nil)
        } else {
            // Show the signup or login screen
            
            self.performSegue(withIdentifier: "toMain", sender: nil)
        }
    }

}
