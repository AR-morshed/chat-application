//
//  UserVC.swift
//  Chat Application
//
//  Created by Arman morshed on 12/6/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //outlet
    @IBOutlet weak var tableView: UITableView!

    //variable
    var userInfo = [User]()
    var ref = Database.database().reference()
    let barButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self,
                                    action: #selector(signOut))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllFIRData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        
    }
    
    func getAllFIRData(){
        
        self.ref.child(USER_REF).observe(DataEventType.value, with: { (snapshot) in
            
            self.userInfo.removeAll()

            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let mainDict = snap.value as? [String: AnyObject] {
                        let name = mainDict[USERNAME] as? String
                        let profileImageURL = mainDict[USER_IMG] as? String ?? ""
                        let key  = snap.key
                        if key != Auth.auth().currentUser?.uid{
                        self.userInfo.append(User(username: name!, profileImage: profileImageURL, userID: key))
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info = userInfo[indexPath.row]
        print(info)
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell
        cell?.user = info
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            let user = self.userInfo[indexPath.row]
            self.showMessageController(user: user)
    }
    
    func showMessageController(user: User){
       
        let messageController = MessageVC1()
            DispatchQueue.main.async {
            
            messageController.user = user
            self.navigationController?.pushViewController(messageController, animated: true)
         
        }
    }

    @objc func signOut(){
        
        let alertVC = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertVC.addAction(cancelAction)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (action) in
            do{
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
                
            }catch let signOutError as NSError{
                print(signOutError)
            }
            
        }
        
        alertVC.addAction(signOutAction)
        self.present(alertVC, animated: true)
    
    }
    
}
