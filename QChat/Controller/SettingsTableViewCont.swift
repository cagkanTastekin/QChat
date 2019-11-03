//
//  SettingsTableViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 31..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> SettingsTVC

import UIKit

class SettingsTableViewCont: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var btnLogOut: UIButton!
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source
    // Section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    // MARK: IBActions
    // Logout function
    @IBAction func logout(_ sender: UIButton) {
        FUser.logOutCurrentUser { (success) in
            if success{
                self.goSignInView()
            }
        }
    }
    
    // MARK: HelperFunctions
    // After logout, view returns sing in view
    @objc func goSignInView(){
        let main = UIStoryboard(name: "Main", bundle: nil)
        let signInView = main.instantiateViewController(withIdentifier: "SignInVC")
        signInView.modalPresentationStyle = .fullScreen
        self.present(signInView, animated: true, completion: nil)
    }
    
}
