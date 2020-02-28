//
//  EditProfileTableViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 16..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> EditProfileTVC

import UIKit
import ProgressHUD
import ImagePicker

class EditProfileTableViewCont: UITableViewController, ImagePickerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var btnSaveButton: UIBarButtonItem!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet var tapGestRecAvatar: UITapGestureRecognizer!
    
    var avatarImage: UIImage?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        setupUI()
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    // MARK: IBActions
    @IBAction func onClickSave(_ sender: UIBarButtonItem) {
        if txtName.text != "" && txtSurname.text != "" && txtEmail.text != "" {
            ProgressHUD.show("Saving")
            
            // Block save button
            btnSaveButton.isEnabled = false
            
            let fullName = txtName.text! + " " + txtSurname.text!
            var withValues = [kFIRSTNAME : txtName.text!, kLASTNAME : txtSurname.text!, kFULLNAME : fullName]
            
            if avatarImage != nil {
                let avatarData = avatarImage!.jpegData(compressionQuality: 0.4)!
                let avatarString = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                withValues[kAVATAR] = avatarString
            }
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error != nil {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(error!.localizedDescription)
                        print("Couldnt update user \(error!.localizedDescription)")
                    }
                    self.btnSaveButton.isEnabled = true
                    return
                }
                ProgressHUD.showSuccess("Saved")
                self.btnSaveButton.isEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            ProgressHUD.show("All fields are required!")
        }
    }
    
    @IBAction func tapAvatar(_ sender: UITapGestureRecognizer) {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Setup UI
    func setupUI() {
        let currentUser = FUser.currentUser()!
        imgAvatar.isUserInteractionEnabled = true
        txtName.text = currentUser.firstname
        txtSurname.text = currentUser.lastname
        txtEmail.text = currentUser.email
        
        if currentUser.avatar != "" {
            imageFromData(pictureData: currentUser.avatar) { (avatar) in
                if imgAvatar != nil {
                    self.imgAvatar.image = avatar!.circleMasked
                }
            }
        }
    }
    
    // MARK: Image Picker Delegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0 {
            self.avatarImage = images.first!
            self.imgAvatar.image = self.avatarImage!.circleMasked
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
