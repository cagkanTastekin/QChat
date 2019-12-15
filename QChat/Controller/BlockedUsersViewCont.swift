//
//  BlockedUsersViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 15..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> BlockedUsersVC

import UIKit
import ProgressHUD

class BlockedUsersViewCont: UIViewController, UITableViewDelegate, UITableViewDataSource, BlockedUsersCellDelegate{
   
    // MARK: Outlets
    @IBOutlet weak var tblBlockedUser: UITableView!
    @IBOutlet weak var lblNoBlockedUser: UILabel!
    
    var blockedUsersArray: [FUser] = []
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tblBlockedUser.tableFooterView = UIView()
        loadUsers()
    }

    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblNoBlockedUser.isHidden = blockedUsersArray.count != 0
        return blockedUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BlockedUsersCell
        cell.delegate = self
        cell.generateCellWith(fUser: blockedUsersArray[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    
    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblBlockedUser.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Unblock"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var tempBlockedUsers = FUser.currentUser()!.blockedUsers
        let userIdToUnblock = blockedUsersArray[indexPath.row].objectId
        tempBlockedUsers.remove(at: tempBlockedUsers.firstIndex(of: userIdToUnblock)!)
        blockedUsersArray.remove(at: indexPath.row)
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : tempBlockedUsers]) { (error) in
            
            if error != nil {
                ProgressHUD.show("Error")
                print(error!.localizedDescription)
            }
            self.tblBlockedUser.reloadData()
        }
    }
    
    // MARK: Load Blocked Users
    func loadUsers() {
        if FUser.currentUser()!.blockedUsers.count > 0 {
            ProgressHUD.show()
            getUsersFromFirestore(withIds: FUser.currentUser()!.blockedUsers) { (allBlockedUsers) in
                ProgressHUD.dismiss()
                self.blockedUsersArray = allBlockedUsers
                self.tblBlockedUser.reloadData()
            }
        }
    }
    
    // MARK: BlockedUsersTableViewCellDelegate
    func didTapAvatarImage(indexPath: IndexPath) {
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "UserProfileTVC") as! UserProfileTableViewCont
        profileVC.user = blockedUsersArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
       }
}
