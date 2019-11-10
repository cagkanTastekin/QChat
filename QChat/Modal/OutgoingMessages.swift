//
//  OutgoingMessages.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 10..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation

class OutgoingMessage {
    let messageDictionary: NSMutableDictionary
    
    // MARK: Initilazers
    // text message
    init(message: String, senderId: String, senderName: String, date: Date, status: String, type: String) {
        messageDictionary = NSMutableDictionary(objects: [message,senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    // MARK: SendMessage
    func sendMessage(chatRoomId: String, messageDictionary: NSMutableDictionary, memberIds: [String], membersToPush: [String]) {
        let messageId = UUID().uuidString
        messageDictionary[kMESSAGEID] = messageId
        
        for memberId in memberIds {
            reference(collectionReference: .Message).document(memberId).collection(chatRoomId).document(messageId).setData(messageDictionary as! [String : Any])
        }
        
        // update Recent chat
        // send push notification
    }
    
    
}
