//
//  UserProfileTableViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 04..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> UserProfileTVC

import UIKit

class UserProfileTableViewCont: UITableViewController {

    // MARK: Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnBlockUser: UIButton!
    
    var user: FUser?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: IBActions
    // Call action
    @IBAction func onClickCall(_ sender: UIButton) {
        // call with user
    }
    
    // Message action
    @IBAction func onClickMessage(_ sender: UIButton) {
        // chat with user
    }
    
    // Block user action
    @IBAction func onClickBlockUser(_ sender: UIButton) {
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId) {
            currentBlockedIds.remove(at: currentBlockedIds.firstIndex(of: user!.objectId)!)
        } else {
            currentBlockedIds.append(user!.objectId)
        }
    
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : currentBlockedIds]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            self.updateBlockStatus()
        }
    }
    
    // MARK: - Table view data source
    // Section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // Row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Header in section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    // View in section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // Height in section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 30
    }
    
    // MARK: SetupUI
    // User Interface
    func setupUI(){
        if user != nil {
            self.title = "Profile"
            lblFullName.text = user!.fullname
            lblPhoneNumber.text = user!.phoneNumber
            updateBlockStatus()
            
            imageFromData(pictureData: user!.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.imgAvatar.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    // Blocked user view
    func updateBlockStatus(){
        if user!.objectId != FUser.currentId() {
            btnBlockUser.isHidden = false
            btnMessage.isHidden = false
            btnCall.isHidden = false
        } else {
            btnBlockUser.isHidden = true
            btnMessage.isHidden = true
            btnCall.isHidden = true
        }
        
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId) {
            btnBlockUser.setTitle("Unblock User", for: .normal)
        } else {
            btnBlockUser.setTitle("Block User", for: .normal)
        }
        
    }
    
}
