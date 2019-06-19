//
//  RegistrationVC.swift
//  Chat Application
//
//  Created by Arman morshed on 12/6/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController, UITextFieldDelegate {

    
    //Outlets
    @IBOutlet private weak var uploadImage: UIImageView!
    @IBOutlet weak var emailTxt: customTextField!
    @IBOutlet weak var usernameTxt: customTextField!
    @IBOutlet weak var passwordTxt: customTextField!
    
    //Variables
    let imagePicker = UIImagePickerController()
    var storageRef: StorageReference!{
        return Storage.storage().reference()
    }
    
    let userDB = Database.database().reference().child(USER_REF)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // TextField Delegate
         emailTxt.delegate = self
         usernameTxt.delegate = self
         passwordTxt.delegate = self
      
        // Round Image
        uploadImage.layer.cornerRadius = 50
        uploadImage.layer.masksToBounds = false
        uploadImage.layer.borderWidth = 1
        uploadImage.clipsToBounds = true

       // Gesture of opening image gallary
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(RegistrationVC.openGallery(tapGesture:)))
        uploadImage.isUserInteractionEnabled = true
        uploadImage.addGestureRecognizer(tap)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        emailTxt.text = ""
        usernameTxt.text = ""
        passwordTxt.text = ""
    }
    
    

      func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
           self.view.endEditing(true)
           return true
    }
    
    @objc func openGallery(tapGesture: UITapGestureRecognizer){
        
        setupImagePicker()
    }
    
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, let password = passwordTxt.text, let username = usernameTxt.text else {return}
        
        imageUpload(uploadImage.image!, username) { url in
                  
            self.saveData(email: email, password: password, username: username, profileURL: url!) { success in
              if success != nil {
                   print("Successfully save Data")
           }
        }
    }
}

  func imageUpload(_ image: UIImage, _ username: String, completion: @escaping ((_ url: URL?) -> ())){

        let storageRef = Storage.storage().reference().child("\(username).png")
        let imageData = uploadImage.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imageData!, metadata: metaData) { (metadata,error) in
                
             if error == nil {
                   print("success")
                   storageRef.downloadURL(completion: { (url, error) in
                 completion(url)
              })
                
            }else{
                 print("error in save image")
                 completion(nil)
            }
       }
   }


    func saveData(email: String, password: String, username: String, profileURL: URL, completion: @escaping ((_ url: URL?) -> ())){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                debugPrint("Error creating the user")
                let alert = UIAlertController(title: "Error", message: "Email is not formatted or password is less than 6 Characters", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }else{

                let key = Auth.auth().currentUser?.uid
                let userInfo  = [USERNAME: username, USER_ID: key, USER_IMG: profileURL.absoluteString]
                self.userDB.child(key!).setValue(userInfo)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc  = storyBoard.instantiateViewController(withIdentifier: "UserVC") as! UIViewController
                 self.navigationController?.pushViewController(vc, animated: true)
                
            }
          }
      }
}

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func setupImagePicker(){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadImage.image = editedImage
        }
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
        
    }
}


