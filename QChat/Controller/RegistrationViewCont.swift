//
//  RegistrationViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 30..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> RegistrationVC

import UIKit
import ProgressHUD

class RegistrationViewCont: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var email:String!
    var password:String!
    var avatarImage:UIImage?
    var name:String = ""
    var surname:String = ""
    var country:String = ""
    var city:String = ""
    var phone:String = ""
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewItems()
    }
    
    // MARK: IBActions
    @IBAction func cancelRegistration(_ sender: UIButton) {
        dismissKeyboard()
        cleanTxtFields()
        cleanAvatarImage()
        goSignUpView()
    }
    
    @IBAction func finishRegistration(_ sender: UIButton) {
        dismissKeyboard()
        //cleanAvatarImage()
        
        ProgressHUD.show("Registering...")
        
        if txtName.text != "" &&
           txtSurname.text != "" &&
           txtCountry.text != "" &&
           txtCity.text != "" &&
           txtPhone.text != ""{
            
            name = txtName.text!
            surname = txtSurname.text!
            country = txtCountry.text!
            city = txtCity.text!
            phone = txtPhone.text!
        
            FUser.registerUserWith(email: email, password: password, firstName: name, lastName: surname) { (error) in
                
                if error != nil {
                    
                    ProgressHUD.showError("badly formatted e-main \nplease check email address")
                    
                    return
                }
                self.registerUser()
            }
            
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
        //cleanTxtFields()
    }
    
    @IBAction func backgroundHelper(_ sender: UIButton) {
        dismissKeyboard()
    }
    
    // MARK: HelperFunctions
    func viewItems(){
       imgBackground.image = UIImage(named: "LoginBackground")
       imgBackground.alpha = 0.3
       imgAvatar.image = UIImage(named: "avatarPlaceholder")
       lblTag.text = "Profile"
    }
    
    @objc func cleanTxtFields(){
        txtName.text = ""
        txtSurname.text = ""
        txtCountry.text = ""
        txtCity.text = ""
        txtPhone.text = ""
    }
    
    @objc func cleanAvatarImage(){
        imgAvatar.image = UIImage(named: "avatarPlaceHolder")
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    @objc func goSignUpView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func registerUser(){
        
        let fullName = name + " " + surname
        var tempDictionary : Dictionary = [kFIRSTNAME : name,
                                           kLASTNAME : surname,
                                           kFULLNAME : fullName,
                                           kCOUNTRY : country,
                                           kCITY : city,
                                           kPHONE : phone] as [String : Any]
        print(avatarImage?.description as Any)
        if avatarImage?.images == nil {
            imageFromInitials(firstName: name, lastName: surname){(avatarInitials) in
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                tempDictionary[kAVATAR] = avatar
                
                self.finishRegistration(withValues: tempDictionary)
            }
        } else {
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.7)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDictionary[kAVATAR] = avatar
            
            self.finishRegistration(withValues: tempDictionary)
        }
    }
    
    @objc func finishRegistration(withValues: [String : Any])  {
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!.localizedDescription)
                }
                return
            }
            ProgressHUD.dismiss()
            // go to app
            
            
        }
    }

}
