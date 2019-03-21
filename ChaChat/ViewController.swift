//
//  ViewController.swift
//  ChaChat
//
//  Created by Yash Nayak on 17/01/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messages: [DataSnapshot]! = [DataSnapshot]()
    
    var ref: DatabaseReference!
    private var _refHandle: DatabaseHandle!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      
        
        if (Auth.auth().currentUser == nil) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "firebaseLoginViewController")
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
        
    }
    
    deinit {
        self.ref.child("messages").removeObserver(withHandle: _refHandle)
    }
    
    func ConfigureDatabase () {
        
        
        
        if FirebaseApp.configure() == nil {
            FirebaseApp.configure()
        }
        
        
        ref = Database.database().reference()
        
        _refHandle = self.ref.child("messages").observe(.childAdded, with: {(snapshot) -> Void in
            
            self.messages.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
            
            })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let messageSnap: DataSnapshot! = self.messages[indexPath.row]
        let message = messageSnap.value as! Dictionary<String, String>
        if let text = message[Constants.MessageFields.text] as String! {
            cell.textLabel?.text = text
        }
        if let subText = message[Constants.MessageFields.dateTime] {
            cell.detailTextLabel?.text = subText
        }
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        
        ConfigureDatabase()
    }
    
    func SendMessage(data: [String: String]) {
        var packet = data
        let userID = Auth.auth().currentUser!.email
        
        var usernameext = userID!.split(separator: "@")[0];

        packet[Constants.MessageFields.dateTime] = "\(usernameext)"
        self.ref.child("messages").childByAutoId().setValue(packet)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    //logout
    @IBAction func logoutbtn(_ sender: Any) {
    
        let firebaseAuth = Auth.auth()
         do {
            try firebaseAuth.signOut()
             print("SUCESS signing out")
         } catch let signOutError as NSError {
         print("error signing out")
         }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.text?.characters.count == 0) {
            return true
        }
        
        let data = [Constants.MessageFields.text: textField.text! as String]
        SendMessage(data: data)
        print("ended editing")
        textField.text = ""
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
