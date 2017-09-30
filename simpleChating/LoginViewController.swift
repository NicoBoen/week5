//
//  LoginViewController.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBAction func loginBtnTapped(_ sender: Any) {
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
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController //1
        let channelVc = navVc.viewControllers.first as! ChannelListViewController //2
        
        channelVc.senderDisplayName = nameTxtField?.text //3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
