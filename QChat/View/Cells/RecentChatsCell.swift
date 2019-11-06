//
//  RecentChatsCell.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 05..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit

protocol RecentChatsCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}

class RecentChatsCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblMessageCounter: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewMessageCounter: UIView!
    
    var indexPath: IndexPath!
    let tapGestureRecognizer = UITapGestureRecognizer()
    var delegate: RecentChatsCellDelegate?
    
    // MARK: OverrideFunctions
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMessageCounter.layer.cornerRadius = viewMessageCounter.frame.width / 2
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: GenerateCell
    func generateCell(recentChat: NSDictionary, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.lblFullname.text = recentChat[kWITHUSERFULLNAME] as? String
        self.lblLastMessage.text = recentChat[kLASTMESSAGE] as? String
        self.lblMessageCounter.text = recentChat[kCOUNTER] as? String
    
        // Avatar
        if let avatarString = recentChat[kAVATAR] {
            imageFromData(pictureData: avatarString as! String) { (avatarImage) in
                if avatarImage != nil {
                    self.imgAvatar.image = avatarImage!.circleMasked
                }
            }
        }
    
        // Unreaded label counter
        if recentChat[kCOUNTER] as! Int != 0 {
            self.lblMessageCounter.text = "\(recentChat[kCOUNTER] as! Int)"
            self.viewMessageCounter.isHidden = true
            self.lblMessageCounter.isHidden = true
        } else {
            self.viewMessageCounter.isHidden = false
            self.lblMessageCounter.isHidden = false
        }
        
        // Date
        var date: Date!
        if let created = recentChat[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)
            }
        } else {
            date = Date()
        }
        self.lblDate.text = timeElapsed(date: date!)
    }

    @objc func avatarTap() {
        delegate?.didTapAvatarImage(indexPath: indexPath)
    }
    
}
