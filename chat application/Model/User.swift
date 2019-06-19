//
//  User.swift
//  Chat Application
//
//  Created by Arman morshed on 13/6/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import Foundation

class User {
     
     private (set) var userID: String?
     private (set) var username : String?
     private (set) var profileImage : String?
    

    init(username: String, profileImage: String, userID: String){
      
      self.username = username
      self.profileImage = profileImage
      self.userID = userID
        
        }
 }
