//
//  SignIn_ViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 1/13/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import CoreGraphics
import Firebase

class SignIn_ViewController: UIViewController , GIDSignInUIDelegate, GIDSignInDelegate {
  var c = ""
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
      
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error! )
    {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    
             // Do any additional setup after loading the view.
      
    }
    func switchScreen()
    {
        var ref : DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
       
        if (userID == nil){
            return}; ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                self.performSegue(withIdentifier: "taoKS", sender: nil)
            }
            else
            {
                self.performSegue(withIdentifier: "quanliKS", sender: nil)
            }
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    
    @IBAction func signInClick(_ sender: Any) {
    
    c = "nope"
    c = UserDefaults.standard.object(forKey: "check") as! String
    print(c)
    if( c == "ok")
    {
    switchScreen()
    }
    }
    @IBOutlet weak var signInButton: GIDSignInButton!
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

