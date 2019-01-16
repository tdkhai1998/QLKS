//
//  ThemKhachHang_Viewcontroller.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
protocol passDataKH {
    func reloadData(_ ten: String,_ ngaysinh: String, _ sodt: String, _ cmnd: String, _ gioitinh: String, _ row: Int )
    
}
class KhachHang_Them_Viewcontroller: UIViewController {
    var btnLabel = ""
    var mode = 0
    var delegate: passDataKH!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    var data1: String = ""
    var data2: String = ""
    var data3: String = ""
    var data4: String = ""
    var data5: Int = 0
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var sdtTxt: UITextField!
    @IBOutlet weak var cmndTxt: UITextField!
    @IBOutlet weak var gioitinhPick: UISegmentedControl!
    @IBOutlet weak var ngaySinhTxt: UITextField!
    @IBOutlet weak var tenTxt: UITextField!
    
 
    
    @IBAction func addClick(_ sender: Any) {
        
        var ref : DatabaseReference!
        
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("KHACHHANG").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                let dateFormat=DateFormatter()
                dateFormat.dateFormat="dd-MM-yyyy"
                let bd = dateFormat.string(from: self.birthdayPicker.date)
                
                let newValue = [
                    "CMND": self.cmndTxt.text!,
                    "GIOITINH": self.gioitinhPick.titleForSegment(at: self.gioitinhPick.selectedSegmentIndex) as Any,
                    "LOAIKH": "Bạc",
                    "NGAYSINH": bd,
                    "SODIENTHOAI": self.sdtTxt.text!,
                    "TENKH": self.tenTxt.text!
                    ] as [String : Any]
                ref.child("users/\(userID!)/KHACHHANG").child(self.cmndTxt.text!).setValue(newValue)
             
                ref.child("users/\(userID!)/KHACHHANG").observe(.childAdded, with: {(snapshot)->Void in
                    let alertController = UIAlertController(title: "Thông Báo", message: "Thêm thành công !", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                   
                    
                })
                return
            }
           
            
            let dateFormat=DateFormatter()
            dateFormat.dateFormat="dd-MM-yyyy"
            let bd = dateFormat.string(from: self.birthdayPicker.date)
            
            let newValue = [
                "CMND": self.cmndTxt.text!,
                "GIOITINH": self.gioitinhPick.titleForSegment(at: self.gioitinhPick.selectedSegmentIndex) as Any,
                "LOAIKH": "Bạc",
                "NGAYSINH": bd,
                "SODIENTHOAI": self.sdtTxt.text!,
                "TENKH": self.tenTxt.text!
                ] as [String : Any]
            ref.child("users/\(userID!)/KHACHHANG").child(self.cmndTxt.text!).setValue(newValue)
            
            ref.child("users/\(userID!)/KHACHHANG").observe(.childAdded, with: {(snapshot)->Void in
                let alertController = UIAlertController(title: "Thông Báo", message: "Thành công !", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            })
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     // Initialization code
        
        delegate.reloadData(self.tenTxt.text!, self.ngaySinhTxt.text!, self.sdtTxt.text!, self.cmndTxt.text!, self.gioitinhPick.titleForSegment(at: self.gioitinhPick.selectedSegmentIndex)!, mode)
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    override func viewDidLoad() {
        registerKeyboardNotifications()
        UI.addDoneButtonForTextField(controls: [self.tenTxt,sdtTxt,cmndTxt])
        super.viewDidLoad()
        doneBtn.setTitle(btnLabel, for: .normal)
       tenTxt.text = data1
      ngaySinhTxt.text = data2
      cmndTxt.text = data3
        sdtTxt.text = data4
       gioitinhPick.selectedSegmentIndex = data5
           // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ngaysinhClick(_ sender: Any) {
        birthdayPicker.isHidden = false
         ngaySinhTxt.resignFirstResponder()
        
    }
    

    @IBAction func bdPick(_ sender: Any) {
        let dateFormat=DateFormatter()
        dateFormat.dateFormat="dd-MM-yyyy"
        self.ngaySinhTxt.text = dateFormat.string(from: birthdayPicker.date)
        birthdayPicker.isHidden = true
       
        
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
