//
//  UsersCell.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 03..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    
    var indexPath: IndexPath!
    
    let tabGestureRecognizer = UITapGestureRecognizer()
    
    // MARK: OverrideFunctions
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
    // When user will tap avatar, detail view gonna show all searched user informations.
    @objc func avatarTap() {
        
    }

}
