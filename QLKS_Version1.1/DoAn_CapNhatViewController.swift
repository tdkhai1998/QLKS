//
//  DoAn_CapNhatViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class DoAn_CapNhatViewController: UIViewController {
    var temp = ""
    var id = ""
    @IBOutlet weak var newPricetxt: UITextField!
    @IBOutlet weak var tenDoAn: UILabel!
    
    @IBOutlet weak var updateClick: UIButton!
    
    @IBAction func updateClick(_ sender: Any) {
        
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let newValue = Int(self.newPricetxt.text!)
        ref.child("users/\(userID!)/FOOD").child(id).child("GIA").setValue(newValue)
        
        ref.child("users/\(userID!)/FOOD").observe(.childAdded, with: {(snapshot)->Void in
            
            let alertController = UIAlertController(title: "Thông Báo", message: "Cập nhật thành công !", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        )
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       tenDoAn.text = temp
        registerKeyboardNotifications()
      UI.addDoneButtonForTextField(controls: [self.newPricetxt])
        
       
    /*
         
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        }
    
    @IBOutlet weak var scrollView: UIScrollView!
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func deregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //cho phép scrollview có thể scroll
        scrollView.isScrollEnabled = true
        
        //lấy thông tin bàn phím để tính toán độ cao
        let info = notification.userInfo!
        let keyboard = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        //Đặt lại content inset của scrollView
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboard!.height, right: 0.0) //Chừa một phần của scrollview đúng bằng chiều cao của bàn phím, đối số thứ ba là bottom
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //lấy thông tin bàn phím để tính độ cao
        let info = notification.userInfo!
        let keyboard = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        //Đặt lại content inset của scrollView
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboard!.height, right: 0.0) //chừa một phần scrollview đúng bằng chiều cao của bàn phím, đối số thứ ba là bottom
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}
