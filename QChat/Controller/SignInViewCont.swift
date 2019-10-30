//
//  SignInViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 30..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit
import ProgressHUD

class SignInViewCont: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewItems()
    }
    
    // MARK: IBActions
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
    
    @IBAction func signUp(_ sender: UIButton) {
        goSignUpVC()
        cleanTxtFields()
        dismissKeyboard()
    }
    
    @IBAction func backgroundHelper(_ sender: UIButton) {
        dismissKeyboard()
    }
    
    // MARK: HelperFunctions
    @objc func goSignUpVC(){
        let main = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = main.instantiateViewController(withIdentifier: "SignUpVC")
        self.present(signUpView, animated: true, completion: nil)
    }
    
    @objc func cleanTxtFields(){
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    @objc func signInUser(){
        ProgressHUD.show("Sing In...")
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        FUser.loginUserWith(email: email, password: password){ (error)in
            
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            self.goToApp()
        }
    }
    
    func viewItems(){
       imgBackground.image = UIImage(named: "LoginBackground")
       imgBackground.alpha = 0.3
       lblTag.text = "QChat"
    }
    
    // MARK: GoToApp
    @objc func goToApp(){
        ProgressHUD.dismiss()
        cleanTxtFields()
        dismissKeyboard()
        // present app here
    }

}
