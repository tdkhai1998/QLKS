//
//  ThietBi_Them_ViewController.swift
//  QLKS_QLITBI
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class ThietBi_Them_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBAction func addClick(_ sender: Any) {
        var ref : DatabaseReference!
        
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("THIETBI").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                let newValue = [
                    "MATHIETBI": "M0",
                    "TENTHIETBI": self.txtTenThietBi.text!,
                    "TINHTRANG": "Ổn định",
                    "PHONG": self.txtPhong.text!
                    ] as [String : Any]
                ref.child("users/\(userID!)/THIETBI").child("M0").setValue(newValue)
                
                ref.child("users/\(userID!)/THIETBI").observe(.childAdded, with: {(snapshot)->Void in
                    let alertController = UIAlertController(title: "Thông Báo", message: "Thêm thành công !", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.txtTenThietBi.text = ""
                    self.txtPhong.text = ""
                    
                })
                return
            }
            var id = 0
            var max = "";
            for (_,j) in value!
            {
                
                max = (j as AnyObject).value(forKey: "MATHIETBI") as! String
                let i = (String(max[max.index(max.startIndex, offsetBy: 1)...]) as NSString).integerValue
                if(i>id){
                    id=i;
                }
                
            }
            let newValue = [
                "MATHIETBI": "M" + "\(id + 1)",
                "TENTHIETBI": self.txtTenThietBi.text!,
                "TINHTRANG": "Ổn định",
                "PHONG": self.txtPhong.text!
                ] as [String : Any]
            
            ref.child("users/\(userID!)/THIETBI").child("M"+"\(id+1)").setValue(newValue)
       
            ref.child("users/\(userID!)/THIETBI").observe(.childAdded, with: {(snapshot)->Void in
                
                let alertController = UIAlertController(title: "Thông Báo", message: "Thêm thành công !", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.txtTenThietBi.text = ""
                self.txtPhong.text = ""
            })
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }//     }
    @IBOutlet weak var txtTenThietBi: UITextField!
    @IBOutlet weak var txtPhong: UITextField!
    var phong: [String] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phong.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return phong[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtPhong.resignFirstResponder()
        txtPhong.text = phong[row]
        phongPicker.isHidden = true
        
    }
    
    @IBAction func EditPhong(_ sender: Any) {
         txtPhong.resignFirstResponder()
        phongPicker.isHidden = false
       
    }
    @IBOutlet weak var phongPicker: UIPickerView!
    @IBOutlet weak var tenThietBi: UITextField!
    
    func loadPhong()
    {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("PHONG").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            
            
            
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                let alertController = UIAlertController(title: "Thông Báo", message: "Chưa có phòng", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            for (_,j) in value!{
                self.phong.append((j as AnyObject).value(forKey: "MAPHONG") as! String)
                
            }
            DispatchQueue.main.async {
                self.phongPicker.reloadAllComponents()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     // Initialization code    }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    override func viewDidLoad() {
        registerKeyboardNotifications()
        super.viewDidLoad()
        loadPhong()
        UI.addDoneButtonForTextField(controls: [self.tenThietBi])
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
