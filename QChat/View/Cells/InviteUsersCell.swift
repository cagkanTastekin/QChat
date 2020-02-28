//
//  InviteUsersCell.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2020. 02. 27..
//  Copyright © 2020. ÇağkanTaştekin. All rights reserved.
//

import UIKit

protocol InviteUsersCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}

class InviteUsersCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    
    var indexPath: IndexPath!
    var delegate: InviteUsersCellDelegate?
    let tabGestureRecognizer = UITapGestureRecognizer()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tabGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: GenerateCell
    func generateCellWith(fUser: FUser, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.lblFullName.text = fUser.fullname
        
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.imgAvatar.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    // MARK: TapToAvatarImage
    @objc func avatarTap() {
        delegate?.didTapAvatarImage(indexPath: indexPath)
    }
}
