//
//  InviteUsersTableViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2020. 02. 27..
//  Copyright © 2020. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> InviteUsersTVC

import UIKit
import ProgressHUD
import Firebase

class InviteUsersTableViewCont: UITableViewController, InviteUsersCellDelegate {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var scFilter: UISegmentedControl!
    
    var allUsers: [FUser] = []
    var allUsersGroupped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList : [String] = []
    
    var newMemberIds: [String] = []
    var currentMemberIds: [String] = []
    var group: NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        loadUsers(filter: kCITY)
    }

    override func viewWillDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users"
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onClickDone))]
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        currentMemberIds = group[kMEMBERS] as! [String]

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.allUsersGroupped.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitleList[section]
        let users = self.allUsersGroupped[sectionTitle]
        return users!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InviteUsersCell
        let sectionTitle = self.sectionTitleList[indexPath.section]
        let users = self.allUsersGroupped[sectionTitle]
       
        cell.generateCellWith(fUser: users![indexPath.row], indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: TableviewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleList[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitleList
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionTitle = self.sectionTitleList[indexPath.section]
        let users = self.allUsersGroupped[sectionTitle]
        let selectedUser = users![indexPath.row]
        
        if currentMemberIds.contains(selectedUser.objectId) {
            ProgressHUD.showError("Already in the group")
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
        
        // add or remove users
        let selected = newMemberIds.contains(selectedUser.objectId)
        
        if selected {
            // REmove
            let objectIndex = newMemberIds.firstIndex(of: selectedUser.objectId)
            newMemberIds.remove(at: objectIndex!)
        } else {
            // add
            newMemberIds.append(selectedUser.objectId)
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = newMemberIds.count > 0
    }

    // MARK: IBActions
    @IBAction func segmentFilter(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    
    @objc func onClickDone() {
        updateGroup(group: group)
    }
    
    func didTapAvatarImage(indexPath: IndexPath) {
        let userProfileTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "UserProfileTVC") as! UserProfileTableViewCont
        
        let sectionTitle = self.sectionTitleList[indexPath.section]
        let users = self.allUsersGroupped[sectionTitle]
        
        userProfileTVC.user = users![indexPath.row]
        userProfileTVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(userProfileTVC, animated: true)
    }
    
    // MARK: Load User
    func loadUsers(filter: String){
        ProgressHUD.show()
        var query: Query!
        
        switch filter {
        case kCITY:
            query = reference(collectionReference: .User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(collectionReference: .User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(collectionReference: .User).order(by: kFIRSTNAME, descending: false)
        }
        
        query.getDocuments { (snapshot, error) in
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroupped = [:]
            
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else{
                ProgressHUD.dismiss()
                return
            }
            
            if !snapshot.isEmpty {
                for userDictionary in snapshot.documents {
                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)
                    
                    if fUser.objectId != FUser.currentId() {
                        self.allUsers.append(fUser)
                    }
                }
                
                // split to groups
                self.splitDataIntoSection()
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    // MARK: HelperFunctions
    
    func updateGroup(group: NSDictionary) {
        let tempMembers = currentMemberIds + newMemberIds
        let tempMembersToPush = group[kMEMBERSTOPUSH] as! [String] + newMemberIds
        let withValues = [kMEMBERS : tempMembers, kMEMBERSTOPUSH : tempMembersToPush]
        
        Group.updateGroup(groupId: group[kGROUPID] as! String, withValues: withValues)
        
        createRecentsForNewMembers(groupId: group[kGROUPID] as! String, groupName: group[kNAME] as! String, membersToPush: tempMembersToPush, avatar: group[kAVATAR] as! String)
        
        updateExistingRecentWithNewValues(chatRoomId: group[kGROUPID] as! String, members: tempMembers, withValues: withValues)
        
        goToGroupChat(membersToPush: tempMembersToPush, members: tempMembers)
    }
    
    func goToGroupChat(membersToPush: [String], members: [String]) {
        let chatVC = ChatViewCont()
        chatVC.titleName = group[kNAME] as? String
        chatVC.memberIds = members
        chatVC.membersToPush = membersToPush
        chatVC.chatRoomId = group[kGROUPID] as? String
        chatVC.isGroup = true
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    // Data split
    fileprivate func splitDataIntoSection() {
        var sectionTitle: String = ""
        
        for i in 0..<self.allUsers.count{
            let currentUser = self.allUsers[i]
            let firstChar = currentUser.firstname.first!
            let firstCharString = "\(firstChar)"
            
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                self.allUsersGroupped[sectionTitle] = []
                self.sectionTitleList.append(sectionTitle)
            }
            self.allUsersGroupped[firstCharString]?.append(currentUser)
        }
    }
}
