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
import MaterialTextField
import Gallery

class RegistrationViewCont: UIViewController, GalleryControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: MFTextField!
    @IBOutlet weak var txtSurname: MFTextField!
    @IBOutlet weak var txtCountry: MFTextField!
    @IBOutlet weak var txtCity: MFTextField!
    @IBOutlet weak var txtPhone: MFTextField!
    @IBOutlet var tapAvatar: UITapGestureRecognizer!
    
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
        setupUI()
        imgAvatar.isUserInteractionEnabled = true
    }
    
    // MARK: IBActions
    // Background helper action
    @IBAction func onClickBackgroundHelper(_ sender: UIButton) {
        dismissKeyboard()
    }
    
    // Register action
    @IBAction func onClickRegister(_ sender: UIButton) {
        dismissKeyboard()
        
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
                    ProgressHUD.showError("badly formatted e-mail \nplease check e-mail address")
                    self.goSignUpView()
                    return
                }
                self.registerUser()
            }
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        cleanTextFields()
    }
    
    // Cancel action
    @IBAction func onClickCancel(_ sender: UIButton) {
        dismissKeyboard()
        cleanTextFields()
        goSignUpView()
    }
    
    
    @IBAction func tappedAvatar(_ sender: Any) {
        let gallery = GalleryController()
        gallery.delegate = self
        
        self.present(gallery, animated: true, completion: nil)
        dismissKeyboard()
    }
    
    // MARK: HelperFunctions
    // UI items
    func setupUI(){
        imgBackground.image = UIImage(named: "loginBackground")
        imgBackground.alpha = 0.1
        imgAvatar.image = UIImage(named: "avatarPlaceholder")
        lblTag.text = "Profile"
        
        let personImage = UIImage(named: "person")
        addLeftImage(txtField: txtName, andImage: personImage!)
        addLeftImage(txtField: txtSurname, andImage: personImage!)
        let countryImage = UIImage(named: "location")
        addLeftImage(txtField: txtCountry, andImage: countryImage!)
        addLeftImage(txtField: txtCity, andImage: countryImage!)
        let phoneImage = UIImage(named: "phone")
        addLeftImage(txtField: txtPhone, andImage: phoneImage!)
        
    }
    
    // Clean text fields
    func cleanTextFields(){
        txtName.text = ""
        txtSurname.text = ""
        txtCountry.text = ""
        txtCity.text = ""
        txtPhone.text = ""
    }
    
    // Dismiss keyboard
    func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    // Go back
    func goSignUpView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // Register user. Creating fullname, dictionary, avatar image and finishRegistration()
    func registerUser(){
        let fullName = name + " " + surname
        var tempDictionary : Dictionary = [kFIRSTNAME : name,
                                           kLASTNAME : surname,
                                           kFULLNAME : fullName,
                                           kCOUNTRY : country,
                                           kCITY : city,
                                           kPHONE : phone] as [String : Any]
        
        if avatarImage == nil {
            imageFromInitials(firstName: name, lastName: surname){(avatarInitials) in
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                tempDictionary[kAVATAR] = avatar
                self.finishRegistration(withValues: tempDictionary)
            }
        } else {
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.5)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDictionary[kAVATAR] = avatar
            self.finishRegistration(withValues: tempDictionary)
        }
    }
    
    // Finish registration
    func finishRegistration(withValues: [String : Any])  {
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!.localizedDescription)
                }
                return
            }
            ProgressHUD.dismiss()
            self.goToApp()
        }
    }
    
    // Go to application
    func goToApp(){
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUSER_DID_LOGIN_NOTIFICATIONS), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        let mainAppView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainApplication") as! UITabBarController
        mainAppView.modalPresentationStyle = .fullScreen
        self.present(mainAppView, animated: true, completion: nil)
    }
    
    // Add left image for textfields.
    func addLeftImage(txtField: MFTextField, andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.width))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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
