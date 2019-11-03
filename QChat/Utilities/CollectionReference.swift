//
//  CollectionReference.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 30..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import FirebaseFirestore

// MARK: CollectionReference
// Lists contact types.
enum FCollectionReference : String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}

func reference(collectionReference : FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
