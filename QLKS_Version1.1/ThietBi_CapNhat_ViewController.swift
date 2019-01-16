//
//  ThietBi_CapNhat_ViewController.swift
//  QLKS_QLITBI
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
protocol updateStatus {
    func setStatus(_ tt: String, _ index: Int)
}
class ThietBi_CapNhat_ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: updateStatus!
    var index = 0
    @IBOutlet weak var maPhong: UILabel!
    
    @IBAction func capNhatClick(_ sender: Any) {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let newValue = self.txtTinhTrang.text!
        ref.child("users/\(userID!)/THIETBI").child(maTB).child("TINHTRANG").setValue(newValue)
        
        ref.child("users/\(userID!)/THIETBI").observe(.childAdded, with: {(snapshot)->Void in
            
            let alertController = UIAlertController(title: "Thông Báo", message: "Cập nhật thành công !", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        )
        
    delegate.setStatus(newValue, index)
    }
    var tenTB = ""
    var ttTB = ""
    var maTB = ""
    var phong = ""
    var tinhTrang: [String] = ["Ổn định", "Đang sửa chữa", "Hư hỏng"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tinhTrang.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tinhTrang[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtTinhTrang.text = tinhTrang[row]
        tinhTrangPicker.isHidden = true
        txtTinhTrang.resignFirstResponder()
    }
    @IBAction func txtTinhTrangEdit(_ sender: Any) {
          txtTinhTrang.resignFirstResponder()
        tinhTrangPicker.isHidden = false
    }
    @IBOutlet weak var txtTinhTrang: UITextField!
    var temp :String = ""
    @IBOutlet weak var TenThietBi: UILabel!
    @IBOutlet weak var tinhTrangPicker: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    override func viewDidLoad() {
        registerKeyboardNotifications()
        super.viewDidLoad()
       TenThietBi.text = tenTB
       txtTinhTrang.text = ttTB
       maPhong.text = phong
        
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
