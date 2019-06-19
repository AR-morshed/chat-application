//
//  MessageVC1.swift
//  Chat Application
//
//  Created by Arman Morshed on 6/17/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class MessageVC1: UIViewController , UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{

    //variables
    var name: String = ""
    var messages = [Message]()
    
    var user: User? {
        didSet{
            navigationItem.title = user?.username
            name = (user?.username)!

        }
    }

    
    lazy var inputTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.textColor = UIColor.black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    lazy var tableView: UITableView = {
       
      let  viewTable = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width,
                       height: view.frame.height - CGFloat(50)))
        viewTable.backgroundColor = UIColor.white
        viewTable.separatorStyle = .none
        viewTable.dataSource = self
        viewTable.delegate = self
        
        return viewTable
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupKeyboardObservers()
        setupInputComponents()
        
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "messageCell")
        getMessages()
        
    }
    
    
    
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
       if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                 let keyboardRectangle = keyboardFrame.cgRectValue
                containerViewBottomAnchor?.constant = -keyboardRectangle.height
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            containerViewBottomAnchor?.constant = 0
        }
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents(){
    
        //Container View
        let containerView = UIView(frame: CGRect(x: 0, y: view.frame.height - CGFloat(50), width: view.frame.width, height: 50))
        view.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //Button
        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        sendButton.setTitleColor(.black, for: .normal)
        
        //TextField
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.black
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive  = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    
    func getMessages(){
        let ref = Database.database().reference().child(MSG_REF)
        ref.observe(.childAdded) { (snapshot) in
            
            if let dictonary = snapshot.value as? [String: Any]{
                let text = dictonary[MSG_TXT] as? String
                let timestamp = dictonary[TIMESTAMP] as? NSNumber
                let fromId = dictonary[MSG_FROM_ID] as? String
                let toId = dictonary[MSG_TO_ID] as? String
                
                if toId == Auth.auth().currentUser?.uid{
                    ref.child(snapshot.key).child(SEEN_STATUS).setValue(true)
                }
                let seen_status = dictonary[SEEN_STATUS] as? Bool
                if (toId == self.user?.userID && fromId! == Auth.auth().currentUser?.uid) || toId == Auth.auth().currentUser?.uid && fromId! == self.user?.userID {
                    self.messages.append(Message(fromId: fromId!, text: text!, timestamp: timestamp!, toId: toId!, seen: seen_status!))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    @objc func handleSend(){
        
        let ref = Database.database().reference().child(MSG_REF)
    
        let fromID = Auth.auth().currentUser?.uid
        let toId = user!.userID!
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let childRef = ref.childByAutoId()
        let values = [MSG_TXT: inputTextField.text!, MSG_TO_ID: toId, MSG_FROM_ID: fromID!, TIMESTAMP: timestamp, SEEN_STATUS: false] as [String : Any]
        childRef.updateChildValues(values)
        inputTextField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        
        cell.textLabel?.text = message.text
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        if let seconds = message.timestamp?.doubleValue {
            
            let timeStampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
           cell.detailTextLabel?.text = dateFormatter.string(from: timeStampDate as Date)
        }
        
        let url = URL(string: (user?.profileImage)!) as! URL
        
    
            if user?.userID != message.toId{
            KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
                
                DispatchQueue.main.async {
                    
                    cell.profileImage.image = image
                    cell.profileImage.kf.indicatorType = .activity
                    
                }
                
            }
        }
        
        if message.seen == true && message.fromId == Auth.auth().currentUser?.uid{
            cell.timeLabel.text = "seen"
        }else{
            cell.timeLabel.text = ""
        }
        cell.getID(toId: message.toId!, fromId: message.fromId!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    
}


