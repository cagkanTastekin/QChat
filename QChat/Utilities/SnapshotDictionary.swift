//
//  SnapshotDictionary.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 05..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

// MARK: Snapshot
// for calls and chats
func dictionarySnapshots(snapshots: [DocumentSnapshot]) -> [NSDictionary] {
    var allMessages: [NSDictionary] = []
    for snapshot in snapshots {
        allMessages.append(snapshot.data()! as NSDictionary)
    }
    return allMessages
}
