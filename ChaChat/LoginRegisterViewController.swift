//
//  LoginRegisterViewController.swift
//  ChaChat
//
//  Created by Yash Nayak on 17/01/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: AnyObject) {

        if (!CheckInput()) {
            return
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                Utilities().ShowAlert(title: "Error!", message: error.localizedDescription, vc: self)
                print(error.localizedDescription)
                return
            }
            print("signed in!")
        })
    }

    @IBAction func registerClicked(_ sender: AnyObject) {
        if (!CheckInput()) {
            return
        }
        
        let alert = UIAlertController(title: "Register", message: "Please confirm password...", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let passConfirm = alert.textFields![0] as UITextField
            if (passConfirm.text!.isEqual(self.passwordTextField.text!)) {
            
                //reg begins
                let email = self.emailTextField.text
                let password = self.passwordTextField.text
                
                Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                    if let error = error {
                        Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else {
                Utilities().ShowAlert(title: "Error", message: "Passwords not the same!", vc: self)
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func CheckInput () -> Bool {
        if ((emailTextField.text?.characters.count)! < 5)
        {
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        } else {
            emailTextField.backgroundColor = UIColor.white
        }
        if ((passwordTextField.text?.characters.count)! < 5)
        {
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        } else {
            passwordTextField.backgroundColor = UIColor.white
        }
        return true
    }
    
    
    @IBAction func forgotClicked(_ sender: AnyObject) {
        if (!emailTextField.text!.isEmpty) {
            let email = self.emailTextField.text
            
            Auth.auth().sendPasswordReset(withEmail: email!, completion: { (error) in
                if let error = error {
                    Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                    return
                }
                Utilities().ShowAlert(title: "Success!", message: "Please check your email!", vc: self)
            })
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
