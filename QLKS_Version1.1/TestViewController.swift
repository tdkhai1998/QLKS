//
//  TestViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 1/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class TestViewController: UIViewController {

    @IBOutlet weak var emaillb: UILabel!
    @IBOutlet weak var usernamelb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        let userName = Auth.auth().currentUser?.email
        
        emaillb.text = userName
        usernamelb.text = userID
        

        ref.child("users").child("wedday2004x").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let data = value?.value(forKey: "PHONG") as! NSArray
            print(data.count)
            for i in data{
                let x = (i as! NSDictionary)["MAPHONG"]
                print(x as! NSNumber)
             }
        
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }        //ref.child("users").child(userID!).setValue(["username": userName])
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
