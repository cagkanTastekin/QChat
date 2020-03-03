//
//  GroupViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2020. 02. 27..
//  Copyright © 2020. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> GrVC

import UIKit
import ProgressHUD
import Gallery

class GroupViewCont: UIViewController, GalleryControllerDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet var tgIcon: UITapGestureRecognizer!
    @IBOutlet weak var btnSave: UIButton!
    
    var group: NSDictionary!
    var groupIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tgIcon)
        
        setupUI()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Invite Users", style: .plain, target: self, action: #selector(self.inviteUsers))]
        
    }

    // MARK: IBActions
    @IBAction func onClickCameraTG(_ sender: UITapGestureRecognizer) {
        showIconOptions()
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        showIconOptions()
    }
    
    @IBAction func onClickSave(_ sender: UIButton) {
        var withValues: [String : Any]!
        
        if txtGroupName.text != "" {
            withValues = [kNAME : txtGroupName.text!]
        } else {
            ProgressHUD.showError("Subject is required")
            return
        }
        
        let avatarData = imgAvatar.image?.jpegData(compressionQuality: 0.4)!
        let avatarString = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        withValues = [kNAME : txtGroupName.text!, kAVATAR : avatarString!]
        
        Group.updateGroup(groupId: group[kGROUPID] as! String, withValues: withValues)
        
        withValues = [kWITHUSERFULLNAME : txtGroupName.text!, kAVATAR : avatarString!]
        
        updateExistingRecentWithNewValues(chatRoomId: group[kGROUPID] as! String, members: group[kMEMBERS] as! [String], withValues: withValues)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func inviteUsers() {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviteUsersTVC") as! InviteUsersTableViewCont
        
        userVC.group = group
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    // MARK: Helper Functions
    func setupUI() {
        self.title = "Group"
        txtGroupName.text = group[kNAME] as? String
        imageFromData(pictureData: group[kAVATAR] as! String) { (avatarImage) in
            if avatarImage != nil {
                self.imgAvatar.image = avatarImage!.circleMasked
            }
        }
    }
    
    func showIconOptions() {
        let optionMenu = UIAlertController(title: "Choose group icon", message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take/Choose Photo", style: .default) { (alert) in
            let gallery = GalleryController()
            gallery.delegate = self
            
            self.present(gallery, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in}
        
        if groupIcon != nil {
            let resetAction = UIAlertAction(title: "Reset", style: .default) { (alert) in
                self.groupIcon = nil
                self.imgAvatar.image = UIImage(named: "cameraIcon")
                self.btnEdit.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: Gallery Delegate
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        print("yes")
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("yes")
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("yes")
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        print("yes")
    }
}
