//
//  GroupChat.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2020. 02. 21..
//  Copyright © 2020. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Group {
    let groupDictionary: NSMutableDictionary
    
    init(groupId: String, subject: String, ownerId: String, members: [String], avatar: String) {
        
        groupDictionary = NSMutableDictionary(objects: [groupId, subject, ownerId, members, members, avatar], forKeys: [kGROUPID as NSCopying, kNAME as NSCopying, kOWNERID as NSCopying, kMEMBERS as NSCopying, kMEMBERSTOPUSH as NSCopying, kAVATAR as NSCopying])
    }
    
    func saveGroup() {
        let date = dateFormatter().string(from: Date())
        groupDictionary[kDATE] = date
        
        reference(collectionReference: .Group).document(groupDictionary[kGROUPID] as! String).setData(groupDictionary as! [String:Any])
    }
    
    class func updateGroup(groupId: String, withValues: [String:Any]) {
        reference(collectionReference: .Group).document(groupId).updateData(withValues)
    }
    
}
