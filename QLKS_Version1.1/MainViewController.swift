//
//  MainView.swift
//  QLKhachSan
//
//  Created by Lê Xuân Kha on 12/1/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import CoreGraphics
import Firebase
import CoreData

class mainView: UIViewController, passData
{
    @IBOutlet weak var button_QLphong: UIButton!
    @IBOutlet weak var labelName: UIButton!
    @IBOutlet weak var labelAddress: UIButton!
    var name:String=""
    var address:String=""
    
    func getData(a: String, b: String) {
        self.name=a;
        self.address=b;
        self.labelName.setTitle(name, for: .normal)
        self.labelAddress.setTitle(address, for: .normal)
    }
   
    func loadInfo()
    {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("KHACHSAN").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            
            
            
            let value = snapshot.value as? NSDictionary
            
            let i = value?.value(forKey: "TENKHACHSAN")
            let j = value?.value(forKey: "DIACHI")
            DispatchQueue.main.async {
                self.getData(a: i as! String, b: j as! String)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     // Initialization code
        // Do any additional setup after loading t
    }
    @IBAction func editName(_ sender: Any) {
        performSegue(withIdentifier: "editInfo", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="editInfo"){
            let subView=segue.destination as! infoViewController
            subView.delegate=self
            subView.name=(labelName.titleLabel?.text)!
            subView.address=(labelAddress.titleLabel?.text)!
        }
    }
    
    
    @IBAction func signOutClick(_ sender: Any) {
            DispatchQueue.main.async {
        GIDSignIn.sharedInstance().signOut()
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "signInView") as! SignIn_ViewController
                self.present(destination, animated: true, completion: nil)
                
                
        }
        
    }
    
    
    @IBOutlet weak var button_QLThietBi: UIButton!
    @IBOutlet weak var button_QLKhachHang: UIButton!
    @IBOutlet weak var button_QLDoAn: UIButton!
    @IBOutlet weak var button_ThongKe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInfo()
        labelName.backgroundColor = .clear;
        button_QLphong.backgroundColor = .clear
        button_QLphong.layer.cornerRadius = 15
        button_QLphong.layer.borderWidth = 1
        button_QLphong.layer.borderColor = UIColor.white.cgColor
        
        button_QLThietBi.backgroundColor = .clear
        button_QLThietBi.layer.cornerRadius = 15
        button_QLThietBi.layer.borderWidth = 1
        button_QLThietBi.layer.borderColor = UIColor.white.cgColor
        
        button_QLDoAn.backgroundColor = .clear
        button_QLDoAn.layer.cornerRadius = 15
        button_QLDoAn.layer.borderWidth = 1
        button_QLDoAn.layer.borderColor = UIColor.white.cgColor
        
        
        button_QLKhachHang.backgroundColor = .clear
        button_QLKhachHang.layer.cornerRadius = 15
        button_QLKhachHang.layer.borderWidth = 1
        button_QLKhachHang.layer.borderColor = UIColor.white.cgColor
        
        
        button_ThongKe.backgroundColor = .clear
        button_ThongKe.layer.cornerRadius = 15
        button_ThongKe.layer.borderWidth = 1
        button_ThongKe.layer.borderColor = UIColor.white.cgColor
    }
   
}
