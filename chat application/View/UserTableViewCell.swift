//
//  UserTableViewCell.swift
//  Chat Application
//
//  Created by Arman morshed on 12/6/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    //outlets
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    
    override func awakeFromNib() {
        profileImage.layer.cornerRadius = 29
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        
    }
   
    var user: User? {
        didSet{
        
        username.text = user?.username
        let url = URL(string: (user?.profileImage)!)
        
        if let url = url{
            KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
                
                DispatchQueue.main.async {
                    
                    self.profileImage.image = image
                    self.profileImage.kf.indicatorType = .activity
                    
                }
                
            }
        
        }

     }

  }

}
