//
//  NewGroupViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2020. 02. 20..
//  Copyright © 2020. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> NewGroupVC

import UIKit
import ProgressHUD

class NewGroupViewCont: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GroupMemberCollectionsCellDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var btnEditAvatar: UIButton!
    @IBOutlet weak var imgGroupIcon: UIImageView!
    @IBOutlet weak var txtGroupSubject: UITextField!
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tgrIcon: UITapGestureRecognizer!
    
    var memberIds: [String] = []
    var allMembers: [FUser] = []
    var groupIcon: UIImage?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        imgGroupIcon.isUserInteractionEnabled = true
        imgGroupIcon.addGestureRecognizer(tgrIcon)
        updateParticipantsLabel()
    }
    
    // MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GroupMemberCollectionsCell
        
        cell.delegate = self
        cell.generateCell(user: allMembers[indexPath.row], indexPath: indexPath)
        
        return cell
    }
    
    // MARK: IBActions
    @objc func createButtonPressed(_ sender: Any) {
        if txtGroupSubject.text != "" {
            memberIds.append(FUser.currentId())
            let avatarData = UIImage(named: "groupIcon")!.jpegData(compressionQuality: 0.7)!
            var avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            if groupIcon != nil {
                let avatarData = groupIcon!.jpegData(compressionQuality: 0.7)!
                avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            }
            
            let groupId = UUID().uuidString
            
            let group = Group(groupId: groupId, subject: txtGroupSubject.text!, ownerId: FUser.currentId(), members: memberIds, avatar: avatar)
            
            group.saveGroup()
            
            // Create group recent
            
            let chatVC = ChatViewCont()
            chatVC.titleName = group.groupDictionary[kNAME] as? String
            chatVC.memberIds = group.groupDictionary[kMEMBERS] as! [String]
            chatVC.membersToPush = group.groupDictionary[kMEMBERS] as! [String]
            chatVC.chatRoomId = groupId
            chatVC.isGroup = true
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        } else {
            ProgressHUD.showError("Subject is required!!")
        }
    }
    
    @IBAction func tapGroupIcon(_ sender: UITapGestureRecognizer) {
        showIconOptions()
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        showIconOptions()
    }
    
    // MARK: Group Member Collection View Delegate
    func didClickDeleteButton(indexPath: IndexPath) {
        allMembers.remove(at: indexPath.row)
        memberIds.remove(at: indexPath.row)
        collectionView.reloadData()
        updateParticipantsLabel()
    }
    

    // MARK: Helper Functions
    func updateParticipantsLabel() {
        lblParticipants.text = "PARTICIPANTS: \(allMembers.count)"
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))]
        self.navigationItem.rightBarButtonItem?.isEnabled = allMembers.count > 0
    }
    
    func showIconOptions() {
        let optionMenu = UIAlertController(title: "Choose group icon", message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take/Choose Photo", style: .default) { (alert) in
            print("camera")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in}
        
        if groupIcon != nil {
            let resetAction = UIAlertAction(title: "Reset", style: .default) { (alert) in
                self.groupIcon = nil
                self.imgGroupIcon.image = UIImage(named: "cameraIcon")
                self.btnEditAvatar.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    

}
