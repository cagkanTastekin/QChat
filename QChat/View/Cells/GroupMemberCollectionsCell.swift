//
//  GroupMemberCollectionsCell.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2020. 02. 20..
//  Copyright © 2020. ÇağkanTaştekin. All rights reserved.
//

import UIKit

protocol GroupMemberCollectionsCellDelegate {
    func didClickDeleteButton(indexPath: IndexPath)
}

class GroupMemberCollectionsCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    
    var indexPath: IndexPath!
    var delegate: GroupMemberCollectionsCellDelegate?
    
    func generateCell(user: FUser, indexPath: IndexPath) {
        self.indexPath = indexPath
        lblName.text = user.firstname
        
        if user.avatar != "" {
            imageFromData(pictureData: user.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.imgAvatar.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        delegate!.didClickDeleteButton(indexPath: indexPath)
    }

}
