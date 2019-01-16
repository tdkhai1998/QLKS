//
//  CreateHotelViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 1/13/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class CreateHotelViewController: UIViewController {

    @IBOutlet weak var diachitxt: UITextField!
    @IBOutlet weak var tenKStxt: UITextField!
    @IBAction func createClick(_ sender: Any) {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let newValue = [
            "TENKHACHSAN": self.tenKStxt.text!,
            "DIACHI": self.diachitxt.text!
        ]
        ref.child("users/\(userID!)/KHACHSAN").setValue(newValue)
        
        ref.child("users/\(userID!)/KHACHSAN").observe(.childAdded, with: {(snapshot)->Void in
            
            let alertController = UIAlertController(title: "Thông Báo", message: "Tạo thành công !", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UI.addDoneButtonForTextField(controls: [tenKStxt,diachitxt])
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
