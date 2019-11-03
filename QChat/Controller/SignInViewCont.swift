//
//  SignInViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 30..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> SignInVC

import UIKit
import ProgressHUD
import MaterialTextField

class SignInViewCont: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var txtEmail: MFTextField!
    @IBOutlet weak var txtPassword: MFTextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var email:String = ""
    var password:String = ""
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewItems()
    }
    
    // MARK: IBActions
    // Sign in action
    @IBAction func signIn(_ sender: UIButton) {
        dismissKeyboard()
        
        if txtEmail.text != "" && txtPassword.text != "" {
            signInUser()
        } else if txtEmail.text != "" && txtPassword.text == ""{
            ProgressHUD.showError("Password missing!")
        } else if txtEmail.text == "" && txtPassword.text != ""{
            ProgressHUD.showError("E-mail missing!")
        } else{
            ProgressHUD.showError("E-mail and password missing!")
        }
    }
    
    // Sign up action
    @IBAction func signUp(_ sender: UIButton) {
        goSignUpVC()
        cleanTxtFields()
        dismissKeyboard()
    }
    
    // Background helper action
    @IBAction func backgroundHelper(_ sender: UIButton) {
        dismissKeyboard()
    }
    
    // MARK: HelperFunctions
    // This method shows to sign up view
    @objc func goSignUpVC(){
        let main = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = main.instantiateViewController(withIdentifier: "SignUpVC")
        signUpView.modalPresentationStyle = .fullScreen
        self.present(signUpView, animated: true, completion: nil)
    }
    
    // Clean text fields
    @objc func cleanTxtFields(){
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    // Dismiss keyboard
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    // Sign in method. if success, app goes to user profile.
    @objc func signInUser(){
        ProgressHUD.show("Sing In...")
        email = txtEmail.text!
        password = txtPassword.text!
        
        FUser.loginUserWith(email: email, password: password){ (error)in
            
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            self.goToApp()
        }
    }
    
    // Add left image for textfields.
    func addLeftImage(txtField: MFTextField, andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.width))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    // UI items
    func viewItems(){
        imgBackground.image = UIImage(named: "loginBackground")
        imgBackground.alpha = 0.1
        lblTag.text = "QChat"
        
        let emailImage = UIImage(named: "email")
        addLeftImage(txtField: txtEmail, andImage: emailImage!)
        let passwordImage = UIImage(named: "password")
        addLeftImage(txtField: txtPassword, andImage: passwordImage!)
    }
    
    // MARK: GoToApp
    // Go to application
    @objc func goToApp(){
        ProgressHUD.dismiss()
        cleanTxtFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUSER_DID_LOGIN_NOTIFICATIONS), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        let mainAppView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainApplication") as! UITabBarController
        mainAppView.modalPresentationStyle = .fullScreen
        self.present(mainAppView, animated: true, completion: nil)
     }

}
