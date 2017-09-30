//
//  ChannelListViewController.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import Firebase

class ChannelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var senderDisplayName: String? //1
    private var channels: [Channel] = [] //3
    
    //Swift 3
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    private var channelRefHandle: FIRDatabaseHandle?
    
    //Swift 4
    //private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    //private var channelRefHandle: DatabaseHandle?
    
    //IBOutlet Table View
    @IBOutlet weak var channelTableView: UITableView!
    
    //Mark: Firebase related methods -> Load data from Firebase
    private func observeChannels(){
        //User the observe method to listen for new
        //Channels being writeen to the Firebase DB
        
        //You call observe:with: on your channel reference, storing a handle to the reference
        //This calls the completion block every time a new channel is added to your database.
        channelRefHandle = channelRef.observe(.childAdded, with: {(snapshot) -> Void in
            //The completion receives a FIRDataSnapshot (stored in snapshot),
            //which contains the data and other helpful methods.
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            //You pull the data out of the snapshot and if succsessful,
            //create a Channel model and addd it to your channels array.
            if let name = channelData["name"] as! String!, name.characters.count > 0{
                self.channels.append(Channel(id: id, name: name))
                self.channelTableView.reloadData()
            }else{
                print("Error! Could not decode channel data")
            }
        })
    }
    
    deinit {
        if let refHandle = channelRefHandle{
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        //1. Create the alert controller
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField{(textField) in
            textField.placeholder = "Input new Channel"
        }
        
        //3. Create Button Cancel.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {[weak alert] (_) in
            let textField = alert?.textFields![0] //Force unwrapping because we know it exists
            if let name = textField?.text{ //1
                let newChannelRef = self.channelRef.childByAutoId() //2
                let channelItem = [ //3
                    "name": name
                ]
                newChannelRef.setValue(channelItem) //4
            }
        }))
        
        //4. Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath)
        cell.textLabel?.text = channels[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToChatSegue", sender: channels[indexPath.row])
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel{
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannels() //akan Error jika function observeChannels belum dibuat
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
