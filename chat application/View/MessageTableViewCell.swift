//
//  MessageTableViewCell.swift
//  Chat Application
//
//  Created by Arman Morshed on 6/17/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {
   
    //variables
    var toId: String?
    var fromId: String?
    
    func getID(toId: String, fromId: String){
        self.toId = toId
        self.fromId = fromId
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        //Draw main body
        bezierPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        //Draw the tail
        
        if fromId == Auth.auth().currentUser?.uid{
        bezierPath.move(to: CGPoint(x: rect.maxX - 25.0, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.0, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.0, y: rect.maxY - 10.0))
        UIColor.lightGray.setFill()
            
        }else{
            bezierPath.move(to: CGPoint(x: rect.minX + 25.0, y: rect.maxY - 10.0))
            bezierPath.addLine(to: CGPoint(x: rect.minX + 10.0, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.minX + 10.0, y: rect.maxY - 10.0))
            UIColor.lightGray.setFill()
        }
        
        bezierPath.fill()
        bezierPath.close()
    }
    
    
    lazy var timeLabel: UILabel = {
            let time = UILabel()
            time.textColor = UIColor.black
            time.text = ""
            time.font = UIFont.systemFont(ofSize: 12)
            time.translatesAutoresizingMaskIntoConstraints = false
            return time
    }()
    
    lazy var profileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width , height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImage)
        contentView.addSubview(timeLabel)

        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        timeLabel.leftAnchor.constraint(equalTo: textLabel!.rightAnchor, constant: 10).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: textLabel!.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
