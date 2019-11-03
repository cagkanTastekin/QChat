//
//  ChatsViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 03..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> ChatsVC

import UIKit

class ChatsViewCont: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var btnNewChat: UIBarButtonItem!
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: IBActions
    // List users for create new chat
    @IBAction func createNewChat(_ sender: UIBarButtonItem) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let usersView = main.instantiateViewController(withIdentifier: "UsersTVC") as! UsersTableViewCont
        usersView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(usersView, animated: true)
    }
    
}


