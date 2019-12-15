//
//  RecentChat.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 05..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation

func startPrivateChat(user1: FUser, user2: FUser) -> String {
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    var chatRoomId = ""
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    } else {
        chatRoomId = userId2 + userId1
    }
    
    let members = [userId1, userId2]
    
    // Create recent chats
    createRecent(members: members, chatRoomId: chatRoomId, withUserUserName: "", typeOfChat: kPRIVATE, users:[user1, user2], avatarofGroup: nil)
    
    return chatRoomId
    
}

func createRecent(members: [String], chatRoomId: String, withUserUserName: String, typeOfChat: String, users: [FUser]?, avatarofGroup: String?){
    
    var tempMembers = members
    
    // if we have recent char, we dont need to create another object
    reference( collectionReference: .Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments {(snapshot, error) in
        
        guard let snapshot = snapshot else {return}
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents{
                let currentRecent = recent.data() as NSDictionary
                if let currentUserId = currentRecent[kUSERID] {
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.firstIndex(of: currentUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in tempMembers {
            // Recent items
            createRecentItems(userId: userId, chatRoomId: chatRoomId, members: members, withUserUserName: withUserUserName, typeOfChat: typeOfChat,users: users, avatarOfGroup: avatarofGroup)
        }
     }

}

// Dynamicly create recent
func createRecentItems(userId: String, chatRoomId: String, members: [String], withUserUserName: String, typeOfChat: String, users: [FUser]?, avatarOfGroup: String?) {
    let localReference = reference(collectionReference: .Recent).document()
    let recentId = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    var recent: [String : Any]!
    
    if typeOfChat == kPRIVATE {
        // Private Chat
        var withUser: FUser?
        
        if users != nil && users!.count > 0 {
            if userId == FUser.currentId() {
                // for current user
                withUser = users!.last!
            } else {
                withUser = users!.first!
            }
        }
        
        recent = [kRECENTID : recentId, kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME : withUser!.fullname, kWITHUSERUSERID : withUser!.objectId, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : typeOfChat, kAVATAR : withUser!.avatar] as [String : Any]
        
    } else {
        // Group Chat
        if avatarOfGroup != nil {
            recent = [kRECENTID : recentId, kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME : withUserUserName, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : typeOfChat, kAVATAR : avatarOfGroup!] as [String : Any]
        }
    }
    
    // save recent chat
    localReference.setData(recent)
}

// MARK: Restart Chat
func restartRecentChat(recent: NSDictionary) {
    if recent[kTYPE] as! String == kPRIVATE {
        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHATROOMID] as! String, withUserUserName: FUser.currentUser()!.firstname, typeOfChat: kGROUP, users: [FUser.currentUser()!], avatarofGroup: recent[kAVATAR] as? String)
    }
    
    if recent[kTYPE] as! String == kGROUP {
        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHATROOMID] as! String, withUserUserName: recent[kWITHUSERFULLNAME] as! String, typeOfChat: kGROUP, users: [FUser.currentUser()!], avatarofGroup: recent[kAVATAR] as? String)
    }
}

// MARK: Update Recents
func updateRecents(chatRoomId: String, lastMessage: String) {
    reference(collectionReference: .Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                updateRecentItem(recent: currentRecent, lastMessage: lastMessage)
            }
        }
    }
}

func updateRecentItem(recent: NSDictionary, lastMessage: String) {
    let date = dateFormatter().string(from: Date())
    var counter = recent[kCOUNTER] as! Int
    
    if recent[kUSERID] as? String != FUser.currentId() {
        counter += 1
    }
    
    let values = [kLASTMESSAGE : lastMessage, kCOUNTER : counter, kDATE : date] as [String : Any]
    reference(collectionReference: .Recent).document(recent[kRECENTID] as! String).updateData(values)
 }

// MARK: Delete Recent
func deleteRecentChat(recentChatDictionary: NSDictionary) {
    if let recentId = recentChatDictionary[kRECENTID] {
        reference(collectionReference: .Recent).document(recentId as! String).delete()
    }
}

// MARK: Clean Counter
func clearRecentCounter(chatRoomId: String) {
    reference(collectionReference: .Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                
                if currentRecent[kUSERID] as? String == FUser.currentId() {
                    clearRecentCounterItem(recent: currentRecent)
                }
            }
        }
    }
}

func clearRecentCounterItem(recent: NSDictionary) {
    reference(collectionReference: .Recent).document(recent[kRECENTID] as! String).updateData([kCOUNTER : 0])
}

func updateExistingRecentWithNewValues(chatRoomId: String, members: [String], withValues: [String : Any]) {
    reference(collectionReference: .Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let recent = recent.data() as NSDictionary
                updateRecent(recentId: recent[kRECENTID] as! String, withValues: withValues)
            }
        }
    }
}

func updateRecent(recentId: String, withValues: [String : Any]) {
    reference(collectionReference: .Recent).document(recentId).updateData(withValues)
}

// MARK: Block USer
func blockUser(userToBlock: FUser) {
    let userId1 = FUser.currentId()
    let userId2 = userToBlock.objectId
    var chatRoomId = ""
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    } else {
        chatRoomId = userId2 + userId1
    }
    
    getRecentsFor(chatRoomId: chatRoomId)
}

func getRecentsFor(chatRoomId: String) {
    reference(collectionReference: .Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let recent = recent.data() as NSDictionary
                deleteRecentChat(recentChatDictionary: recent)
            }
        }
    }
}
