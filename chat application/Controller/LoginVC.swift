//
//  LoginVC.swift
//  Chat Application
//
//  Created by Arman morshed on 12/6/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

   //outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.text = ""
        passwordTxt.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTxt.text = ""
        passwordTxt.text = ""
    }

    @IBAction func loginBtnPressed(_ sender: Any){

        guard let email = emailTxt.text, let password = passwordTxt.text else
        { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print("Error in Sign IN")
                
                let alert = UIAlertController(title: "Error", message: "Incorrect email or password", preferredStyle: .actionSheet)
                
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else {
            
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc  = storyBoard.instantiateViewController(withIdentifier: "UserVC")
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
}

