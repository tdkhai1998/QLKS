//
//  ViewController.swift
//  QLKhachSan
//
//  Created by Lê Xuân Kha on 12/1/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
protocol passData {
    func getData(a:String,b:String);
}
class infoViewController: UIViewController {
    var delegate:passData!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var textFieldAddress: UITextField!
    override func viewDidLoad() {
        registerKeyboardNotifications()
        UI.addDoneButtonForTextField(controls: [textFieldName,textFieldAddress])
        super.viewDidLoad()
        self.textFieldName.text=self.name
        self.textFieldAddress.text=self.address
    }
    var name:String=""
    var address:String=""
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    @IBAction func saveButtonTouchDown(_ sender: Any) {
        delegate.getData(a: self.textFieldName.text!, b: self.textFieldAddress.text!)
        
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("KHACHSAN").setValue(["DIACHI": self.textFieldAddress.text , "TENKHACHSAN":self.textFieldName.text ] as! [String:String])
        self.navigationController?.popViewController(animated: true)
    }
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func deregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
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

