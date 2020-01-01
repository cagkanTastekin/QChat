//
//  SettingsTableViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 31..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> SettingsTVC

import UIKit
import ProgressHUD

class SettingsTableViewCont: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var btnBlockedUser: UIButton!
    @IBOutlet weak var btnChatBackgrounds: UIButton!
    @IBOutlet weak var lblShowAvatar: UILabel!
    @IBOutlet weak var swtcShowAvatar: UISwitch!
    @IBOutlet weak var btnClearCache: UIButton!
    @IBOutlet weak var btnTellAFriend: UIButton!
    @IBOutlet weak var btnTermsAndConditions: UIButton!
    @IBOutlet weak var lblVersionLabel: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    var avatarSwitchStatus = false
    let userDefaults = UserDefaults.standard
    var firstLoad: Bool?
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        if FUser.currentUser() != nil {
            setupUI()
            loadUserDefaults()
        }
    }
    
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        lblShowAvatar.text = "Show Avatar"
        tableView.tableFooterView = UIView() // remove empty cells
    }

    // MARK: - Table view data source
    // Section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    // Row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        } else {
            return 2
        }
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 0 {
            return 0
        }
        
        return 30
    }

    // MARK: IBActions
    // Blocked User
    @IBAction func onClickBlockedUser(_ sender: UIButton) {
        
    }
    
    // Chat Backgrounds
    @IBAction func onClickChatBackgrounds(_ sender: UIButton) {
        
    }
    
    // Avatar Status Switch
    @IBAction func switchShowAvatar(_ sender: UISwitch) {
        avatarSwitchStatus = sender.isOn
        
        saveUserDefaults()
        
    }
    
    // Clear Cache
    @IBAction func onClickClearCache(_ sender: UIButton) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsURL().path)
            
            for file in files {
                try FileManager.default.removeItem(atPath: "\(getDocumentsURL().path)/\(file)")
            }
            
            ProgressHUD.showSuccess("Cache Cleaned 👍")
        } catch {
            ProgressHUD.showError("Couldn't Clean Media Files ❗️")
        }
    }
    
    // Tell a Friend
    @IBAction func onClickTellAFriend(_ sender: UIButton) {
        let text = "Hey! Lets chat on QChat \(kAPPURL)"
        let objectsToShare: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue("Lets Chat on QChat", forKey: "subject")
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    // Logout function
    @IBAction func onClickLogout(_ sender: UIButton) {
        FUser.logOutCurrentUser { (success) in
            if success{
                self.goSignInView()
            }
        }
    }
    
    // Delete Account
    @IBAction func onClickDeleteAccount(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete the account", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            self.deleteUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
    
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: HelperFunctions
    // After logout, view returns sing in view
    func goSignInView(){
        let main = UIStoryboard(name: "Main", bundle: nil)
        let signInView = main.instantiateViewController(withIdentifier: "SignInVC")
        signInView.modalPresentationStyle = .fullScreen
        self.present(signInView, animated: true, completion: nil)
    }
    
    // MARK: SetupUI
    func setupUI() {
        let currentUser = FUser.currentUser()!
        lblFullName.text = currentUser.fullname
        
        if currentUser.avatar != "" {
            imageFromData(pictureData: currentUser.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.imgAvatar.image = avatarImage!.circleMasked
                }
            }
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text = version
        }
    }
    
    // MARK: Delete User
    func deleteUser() {
        // Delete locally
        userDefaults.removeObject(forKey: kPUSHID)
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        // Delete From Firebase
        reference(collectionReference: .User).document(FUser.currentId()).delete()
        FUser.deleteUser { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError("Couldn't delete user")
                }
                return
            }
            self.goSignInView()
        }
    }
    
    // MARK: User Defaults
    func saveUserDefaults() {
        userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
        userDefaults.synchronize()
    }
    
    func loadUserDefaults() {
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
            userDefaults.synchronize()
        }
        
        avatarSwitchStatus = userDefaults.bool(forKey: kSHOWAVATAR)
        swtcShowAvatar.isOn = avatarSwitchStatus
    }
}
