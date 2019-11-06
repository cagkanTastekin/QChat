//
//  ChatsViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 03..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> ChatsVC
// Custom Cell ID --> Cell

import UIKit
import FirebaseFirestore

class ChatsViewCont: UIViewController, UITableViewDelegate, UITableViewDataSource,RecentChatsCellDelegate, UISearchResultsUpdating {
    
    // MARK: Outlets
    @IBOutlet weak var btnNewChat: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var recentChats: [NSDictionary] = []
    var filteredChats: [NSDictionary] = []
    var recentListener: ListenerRegistration!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
       // searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        loadRecentChats()
        
        settableViewHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recentListener.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentChats()
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: IBActions
    // List users for create new chat
    @IBAction func onClickCreateNewChat(_ sender: UIBarButtonItem) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let usersView = main.instantiateViewController(withIdentifier: "UsersTVC") as! UsersTableViewCont
        usersView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(usersView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recentChats.count)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredChats.count
        } else {
            return recentChats.count
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentChatsCell
        cell.delegate = self
        var recent: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            recent = filteredChats[indexPath.row]
        } else {
            recent = recentChats[indexPath.row]
        }
        
        cell.generateCell(recentChat: recent, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    // MARK: LoadRecentChats
    func loadRecentChats() {
        recentListener = reference(collectionReference: .Recent).whereField(kUSERID, isEqualTo: FUser.currentId()).addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else { return }
            self.recentChats = []
            if !snapshot.isEmpty {
                let sorted = (dictionarySnapshots(snapshots: snapshot.documents) as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)]) as! [NSDictionary]
                
                for recent in sorted {
                    if recent[kLASTMESSAGE] as! String != "" && recent[kCHATROOMID] != nil && recent[kRECENTID] != nil {
                        self.recentChats.append(recent)
                    }
                }
                self.tableView.reloadData()
            }
        })
            
    }
    
    // MARK: Custom tableView Header
    func settableViewHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        let buttonView = UIView(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 35))
        let groupChatButton = UIButton(frame: CGRect(x: tableView.frame.width - 110, y: 10, width: 100, height: 20))
        groupChatButton.addTarget(self, action: #selector(self.groupButtonPressed), for: .touchUpInside)
        groupChatButton.setTitle("New Group", for: .normal)
        let buttonColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        groupChatButton.setTitleColor(buttonColor, for: .normal)
        
        let lineView = UIView(frame: CGRect(x: 0, y: headerView.frame.height - 1, width: tableView.frame.width, height: 1))
        
        lineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        buttonView.addSubview(groupChatButton)
        headerView.addSubview(buttonView)
        headerView.addSubview(lineView)
        tableView.tableHeaderView = headerView
    }
    
    @objc func groupButtonPressed(){
        print("Working!")
    }
    
    // MARK: RecentChatsCellDelegate
    func didTapAvatarImage(indexPath: IndexPath) {
        
        var recentChat: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            recentChat = filteredChats[indexPath.row]
        } else {
            recentChat = recentChats[indexPath.row]
        }
        
        
        if recentChat[kTYPE] as! String == kPRIVATE {
            reference(collectionReference: .User).document(recentChat[kWITHUSERUSERID] as! String).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                if snapshot.exists {
                    let userDictionary = snapshot.data()! as NSDictionary
                    let tempUser = FUser(_dictionary: userDictionary)
                    self.showUserProfile(user: tempUser)
                }
            }
        }
    }

    func showUserProfile(user: FUser){
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "UserProfileTVC") as! UserProfileTableViewCont
        profileVC.user = user
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // MARK: SearchControllerFunctions
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredChats = recentChats.filter({ (recentChat) -> Bool in
            return (recentChat[kWITHUSERFULLNAME] as! String).lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}


