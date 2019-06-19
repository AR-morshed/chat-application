//
//  Message.swift
//  Chat Application
//
//  Created by Arman Morshed on 6/16/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Message {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var seen: Bool?
    
    init(fromId: String, text: String, timestamp: NSNumber, toId: String, seen: Bool){
        self.fromId = fromId
        self.text = text
        self.timestamp = timestamp
        self.toId = toId
        self.seen = seen
    }
    
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid{
            return toId
        }else {
            return fromId
        }
    }
    
}
