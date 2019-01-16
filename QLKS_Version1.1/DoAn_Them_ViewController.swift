//
//  DoAn_Them_ViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
protocol reData{
    func passData(_: String,_:String,_:String)
}
class DoAn_Them_ViewController: UIViewController {
    var delegate: reData!
    @IBAction func addClick(_ sender: Any) {
        var ref : DatabaseReference!
       
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("FOOD").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                let newValue = [
                    "MATHUCPHAM": "F0",
                    "TENTHUCPHAM": self.tenTxt.text!,
                    "GIA": Int(self.donGiaTxt.text!) as Any
                    ] as [String : Any]
                ref.child("users/\(userID!)/FOOD").child("F0").setValue(newValue)
                self.delegate.passData("F0",self.tenTxt.text!,self.donGiaTxt.text!)
                ref.child("users/\(userID!)/FOOD").observe(.childAdded, with: {(snapshot)->Void in
                    let alertController = UIAlertController(title: "Thông Báo", message: "Thêm thành công !", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.tenTxt.text = ""
                    self.donGiaTxt.text = ""
                    
                })
                return
            }
            var id = 0
            var max = "";
            for (_,j) in value!
            {
         
                max = (j as AnyObject).value(forKey: "MATHUCPHAM") as! String
                let i = (String(max[max.index(max.startIndex, offsetBy: 1)...]) as NSString).integerValue
                if(i>id){
                    id=i;
                }
                
            }
            let newValue = [
                "MATHUCPHAM": "F" + "\(id + 1)",
                "TENTHUCPHAM": self.tenTxt.text!,
                "GIA": Int(self.donGiaTxt.text!) as Any
                ] as [String : Any]
            
            ref.child("users/\(userID!)/FOOD").child("F"+"\(id+1)").setValue(newValue)
            self.delegate.passData("F" + "\(id + 1)", self.tenTxt.text!, self.donGiaTxt.text!)
            ref.child("users/\(userID!)/FOOD").observe(.childAdded, with: {(snapshot)->Void in
          
                let alertController = UIAlertController(title: "Thông Báo", message: "Thêm thành công !", preferredStyle: .alert)
             
                let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.tenTxt.text = ""
                self.donGiaTxt.text = ""
            })
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     // Initialization code
        
    }
 
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tenTxt: UITextField!
    @IBOutlet weak var donGiaTxt: UITextField!
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UI.addDoneButtonForTextField(controls: [tenTxt,donGiaTxt])
        registerKeyboardNotifications()
        // Do any additional setup after loading the view.
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
