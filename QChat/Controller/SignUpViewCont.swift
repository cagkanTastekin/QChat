//
//  SignUpViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 30..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> SignUpVC

import UIKit
import ProgressHUD

class SignUpViewCont: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var email:String = ""
    var password:String = ""
    var repeatPassword:String = ""
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewItems()
    }
   
    // MARK: IBActions
    @IBAction func signUp(_ sender: UIButton) {
        dismissKeyboard()
        
        if txtEmail.text != "" && txtPassword.text != "" && txtRepeatPassword.text != ""{
            if txtPassword.text == txtRepeatPassword.text {
                let mail = String(txtPassword.text!)
                if mail.count < 6{
                    print("az")
                    ProgressHUD.showError("Password must to be minimum 6 characters")
                } else {
                    registerNewUser()
                    cleanTxtFields()
                }
            } else {
                ProgressHUD.showError("OOPS!! \n Passwords doesn't match!")
            }
        } else if txtEmail.text != "" && txtPassword.text != "" && txtRepeatPassword.text == ""{
            ProgressHUD.showError("Please repeat password!")
        } else if txtEmail.text != "" && txtPassword.text == "" && txtRepeatPassword.text != ""{
            ProgressHUD.showError("Password required!")
        } else if txtEmail.text == "" && txtPassword.text != "" && txtRepeatPassword.text != ""{
            ProgressHUD.showError("Please don't forget to e-mail!")
        } else if txtEmail.text != "" && txtPassword.text == "" && txtRepeatPassword.text == ""{
            ProgressHUD.showError("Passwords required!")
        } else if txtEmail.text == "" && txtPassword.text != "" && txtRepeatPassword.text == ""{
            ProgressHUD.showError("E-mail required and \nrepeat password please!")
        } else if txtEmail.text == "" && txtPassword.text == "" && txtRepeatPassword.text != ""{
            ProgressHUD.showError("E-mail and password required!")
        } else{
            ProgressHUD.showError("All Fields are required")
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        cleanTxtFields()
        dismissKeyboard()
        goSignInView()
    }
    
    @IBAction func backgroundHelper(_ sender: UIButton) {
        dismissKeyboard()
    }
    
    //MARK: HelperFunctions
    @objc func cleanTxtFields(){
        txtEmail.text = ""
        txtPassword.text = ""
        txtRepeatPassword.text = ""
    }
    
    @objc func goSignInView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    func viewItems(){
       imgBackground.image = UIImage(named: "LoginBackground")
       imgBackground.alpha = 0.3
       lblTag.text = "Sign Up"
    }
    
    @objc func registerNewUser(){
        email = txtEmail.text!
        password = txtPassword.text!
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationViewCont
        vc?.email = email
        vc?.password = password
        self.present(vc!, animated: true, completion: nil)
    }
    
}
