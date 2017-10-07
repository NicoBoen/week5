//
//  LoginViewController.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var passTxtFieldLogin: UITextField!
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var nameTxtFieldSignUp: UITextField!
    @IBOutlet weak var passTxtFieldSignUp: UITextField!
    @IBOutlet weak var rePassTxtFieldSignUp: UITextField!
    
    @IBOutlet weak var loginWithEmailView: UIView!
    @IBOutlet weak var nameTxtFieldLoginWithEmail: UITextField!
    
    @IBOutlet weak var buttonAtas: UIButton!
    @IBOutlet weak var buttonBawah: UIButton!
    @IBAction func buttonAtasTapped(_ sender: Any) {
        if signUpView.isHidden == true && loginWithEmailView.isHidden == true {
            loginView.isHidden = true
            signUpView.isHidden = false
            loginWithEmailView.isHidden = true
            
            buttonAtas.setTitle("Login with Email", for: .normal)
            buttonBawah.setTitle("Login as Anonymous", for: .normal)
        }else if loginView.isHidden == true && loginWithEmailView.isHidden == true{
            loginWithEmailView.isHidden = false
            loginView.isHidden = true
            signUpView.isHidden = true
            
            buttonAtas.setTitle("Login with Email", for: .normal)
            buttonBawah.setTitle("Sign Up", for: .normal)
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        if nameTxtFieldSignUp.text == "" || passTxtFieldSignUp.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.createUser(withEmail: nameTxtFieldSignUp.text!, password: passTxtFieldSignUp.text!) {(user, error) in
                
                if error == nil{
                    print("You have successfully signed up")
                    //Do something segue or anything...
                    self.signUpView.isHidden = true
                    self.loginView.isHidden = false
                    self.loginWithEmailView.isHidden = true
                    
                    self.buttonAtas.setTitle("Sign Up", for: .normal)
                    self.buttonBawah.setTitle("Login as Anonymous", for: .normal)
                }else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginWithEmailBtnTapped(_ sender: Any) {
        if nameTxtField.text != ""{
            FIRAuth.auth()?.signInAnonymously(completion: {(user, error) in
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "loginToChatSegue", sender: nil)
            })
        }
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        if nameTxtField.text! == "" || passTxtFieldLogin.text! == ""{
            //Alert to tell the user that there was an error if Field nil
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.signIn(withEmail: self.nameTxtField.text!, password: self.passTxtFieldLogin.text!){(user, error) in
                
                if error == nil{
                    //Print into the console if successfullly logged in
                    print("You have successfully logged in")
                    //Go to Homepage if the login is successful
                    //Do segue here...
                    self.performSegue(withIdentifier: "loginToChatSegue", sender: nil)
                }else{
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func forgotPassActionButton(_ sender: Any) {
        if nameTxtField.text == ""{
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
        }else{
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.nameTxtField.text!, completion: {(error) in
                var title = ""
                var message = ""
                
                if error != nil{
                    title = "Error!"
                    message = (error?.localizedDescription)!
                }else{
                    title = "Success!"
                    message = "Password reset email sent"
                    self.nameTxtField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController //1
        let channelVc = navVc.viewControllers.first as! ChannelListViewController //2
        
        channelVc.senderDisplayName = nameTxtField?.text //3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.isHidden = false
        signUpView.isHidden = true
        loginWithEmailView.isHidden = true
        
        buttonAtas.setTitle("Sign Up", for: .normal)
        buttonBawah.setTitle("Login as Anonymous", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
