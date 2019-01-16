//
//  PhongViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
class KhachHang{
    var CMND:String!="";
    var GioiTinh:String=""
    var Loai: String!="";
    var NgaySinh: String!="";
    var SDT: String!="";
    var Ten: String!="";
}
protocol datPhong{
    func datThanhCong();
    func datThucAn();
    func themPhongTC(_ p: Phong);
}
class PhongTrongViewController: UIViewController {

    @IBOutlet weak var button_Ngaysinh: UIButton!
    @IBOutlet weak var button_Ngaydatphong: UIButton!
    //@IBOutlet weak var button_ngaydatphong: UIButton!
  
    @IBOutlet weak var SavedataButton: UIButton!
    @IBOutlet weak var datepicker_ngaysinh: UIDatePicker!
    @IBOutlet weak var datepicker_ngaydatphong: UIDatePicker!
    var delegate: datPhong!;
    var KH: KhachHang!;
    
    func setdayDefault(){
        button_Ngaydatphong.setTitle(getDate2(), for: .normal)
        
        let dateString = "01-01-2000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateString)
        
        datepicker_ngaysinh.setDate(date!, animated: false)
        
        button_Ngaysinh.setTitle(getDate1(), for: .normal)
    }
    
    //@IBOutlet weak var datepicker_ngaydatphong: UIDatePicker!
    @IBOutlet weak var cmnd: UITextField!
    
    @IBAction func touchdown_buttonNgaysinh(_ sender: Any) {
        if (datepicker_ngaysinh.isHidden == false) {
            datepicker_ngaysinh.isHidden = true
            
        }
        else {
            
            datepicker_ngaydatphong.isHidden = true
            datepicker_ngaysinh.isHidden = false
            
        }
    }
    
    @IBAction func touchdown_button_ngaydatphong(_ sender: Any) {
        if (datepicker_ngaydatphong.isHidden == false) {
            datepicker_ngaydatphong.isHidden = true
            
        }
        else {
            
            datepicker_ngaysinh.isHidden = true
            datepicker_ngaydatphong.isHidden = false
            
        }
    }
   
    @IBAction func touchdown_button_saveData(_ sender: Any) {
        self.SavedataButton.isUserInteractionEnabled = false
        showAlert()
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let newRoom=[
            "GIAPHONG": (self.Gia.text! as NSString).integerValue,
            "LOAIPHONG":(self.Loai.text! as NSString).integerValue,
            "SUCCHUA":(self.sucChua.text! as NSString).integerValue,
            "TINHTRANG":"Rảnh",
            "MAPHONG": "P"+self.TenPhong.text!
        ] as [String :Any]
        ref.child("users").child(userID!).child("PHONG/P"+self.TenPhong.text!).setValue(newRoom);
        ref.child("users").child(userID!).child("PHONG/P"+self.TenPhong.text!).observe(.childAdded, with: {(snapshot)->Void in
            let alertController = UIAlertController(title: "Thông Báo", message: "Thêm thành công !", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: {(n) in
                let p:Phong=Phong()
                p.giaphong=(self.Gia.text! as NSString).integerValue
                p.loaiphong=(self.Loai.text! as NSString).integerValue
                p.succhua=(self.sucChua.text! as NSString).integerValue
                p.trangthai=false;
                p.maphong="P"+self.TenPhong.text!
                self.delegate.themPhongTC(p);
                
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(defaultAction)
            self.mode_add=false;
            self.present(alertController, animated: true, completion: nil)
        })
        self.SavedataButton.isUserInteractionEnabled = true
    }
    var popup:UIView!
    var label:UILabel!
    func showAlert() {
        
        // customise your view
        /*popup = UIView(frame: CGRect(x: 100, y: 200, width: 150, height: 70))
        popup.backgroundColor = UIColor.gray
        self.view.addSubview(popup)
        popup.center = self.view.center
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 70))
        //label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Save"
        label.font = label.font.withSize(40)
        self.popup.addSubview(label)
        // show on screen
        
        
        // set the timer
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)*/
        
    }
    
    

    
    //@IBAction func touchdown_ngaydatphong(_ sender: Any) {
        
    
    @IBAction func changevalue_daypicker_ngaysinh(_ sender: Any) {
        button_Ngaysinh.setTitle(getDate1(), for: .normal)
    }
    
    @IBAction func changevalue_daypicker_ngaydatphong(_ sender: Any) {
        button_Ngaydatphong.setTitle(getDate2(), for: .normal)
    }
    
    func getDate1()->String{
        let dateFormat=DateFormatter()
        dateFormat.dateFormat="dd/MMM/yyyy"
        return dateFormat.string(from: datepicker_ngaysinh.date)
    }
    func getDate2()->String{
        let dateFormat=DateFormatter()
        dateFormat.dateFormat="hh:mma dd/MMM/yyyy"
        dateFormat.amSymbol = "AM"
        dateFormat.pmSymbol = "PM"
        return dateFormat.string(from: datepicker_ngaydatphong.date)
    }
    
    
    
    @IBOutlet weak var btn_xacNhan: UIButton!
    var ischeck:Bool=false;
    @IBAction func checkInfo(_ sender: Any) {
        KH=KhachHang()
        showinfo()
        ischeck=false;
        self.HoTen.isEnabled=true;
        self.GioiTinh.isEnabled=true
        self.button_Ngaysinh.isEnabled=true
        self.SDT.isEnabled=true
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            if(value != nil){
                let value2=value as! Dictionary<String, AnyObject>
                let value3 = value2["KHACHHANG"];
                if(value3 != nil){
                    let data = value3 as! Dictionary<String, AnyObject>
                    for i in data{
                        let d=self.cmnd.text;
                        let data=i.value as! NSDictionary
                        if(data["CMND"] as! String)==d{
                            self.ischeck=true
                            self.KH=KhachHang();
                            self.KH.CMND=d;
                            self.KH.Ten=(data["TENKH"] as! String);
                            self.KH.GioiTinh=(data["GIOITINH"] as! String);
                            self.KH.NgaySinh=(data["NGAYSINH"] as! String);
                            self.KH.Loai=(data["LOAIKH"] as! String);
                            self.KH.SDT=(data["SODIENTHOAI"] as! String);
                            
                              
                            self.showinfo();
                            self.HoTen.isEnabled=false;
                            self.GioiTinh.isEnabled=false
                            self.button_Ngaysinh.isEnabled=false
                            self.SDT.isEnabled=false
                                
                            self.HoTen.text=self.KH.Ten;
                            
                            self.GioiTinh.selectedSegmentIndex=1;
                            if(self.KH.GioiTinh=="Nam"){
                                self.GioiTinh.selectedSegmentIndex=0;
                            }
                            
                            self.button_Ngaysinh.setTitle(self.KH.NgaySinh, for: .normal);
                            self.LoaiKH.text=self.KH.Loai;
                            self.SDT.text=self.KH.SDT;
                        }
                        let alertController = UIAlertController(title: "Thông Báo", message: "Không tìm thấy!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: {(n) in
                          
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }

                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    var mabill=0;
    @IBAction func XacNhan(_ sender: Any) {
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if(!ischeck){
            let newValue = [
                "CMND": self.cmnd!.text! as  NSString ,
                "GIOITINH": self.GioiTinh.titleForSegment(at: self.GioiTinh.selectedSegmentIndex) as Any ,
                "LOAIKH": "Đồng",
                "NGAYSINH": button_Ngaysinh.titleLabel?.text as Any,
                "SODIENTHOAI": self.SDT.text as Any,
                "TENKH": self.HoTen.text as Any
                ] as [String : Any]
            ref.child("users").child(userID!).child("KHACHHANG/"+cmnd.text!).setValue(newValue);
            self.HoTen.isEnabled=false;
            self.GioiTinh.isEnabled=false
            self.button_Ngaysinh.isEnabled=false
            self.SDT.isEnabled=false
        }
        let val=[
            "MABILL":"B"+(mabill as NSNumber).stringValue,
            "CHECKIN_TIME": dateFormatter.string(from: Date()),
            "CHECKOUT_TIME":"NULL",
            "DONGIA": phong.giaphong,
            "KHACHHANG": (self.cmnd.text! as NSString).integerValue,
            "PHONG": phong.maphong,
            "SERVICE_FEE":0,
            "TOTAL":0
            
            ] as [String:Any]
        ref.child("users").child(userID!).child("BILL/B"+(mabill as NSNumber).stringValue).setValue(val)
        ref.child("users").child(userID!).child("PHONG/"+phong.maphong+"/TINHTRANG").setValue("Bận")
        
        ref.child("users").child(userID!).child("BILL").observe(.childAdded, with: {(snapshot)->Void in
            let alertController = UIAlertController(title: "Thông Báo", message: "Đặt phòng thành công !", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler:
            {(snap ) in
                self.navigationController?.popViewController(animated: true)
                self.delegate.datThanhCong()
            })
            let defaultAction2 = UIAlertAction(title: "Đặt Thức Ăn", style: .default, handler:  {(snap ) in
                self.navigationController?.popViewController(animated: true)
                self.delegate.datThucAn()
            })
            self.mode_add=false
            alertController.addAction(defaultAction)
            alertController.addAction(defaultAction2)
            self.present(alertController, animated: true, completion: nil)
        })
        
        
    }
    var dateFormatter=DateFormatter();
  
    func showinfo(){
        
        
        
    }
    @IBOutlet weak var SDT: UITextField!
    @IBOutlet weak var LoaiKH: UILabel!
    @IBOutlet weak var GioiTinh: UISegmentedControl!
    @IBOutlet weak var HoTen: UITextField!
    @IBOutlet weak var Gia: UITextField!
    @IBOutlet weak var sucChua: UITextField!
    @IBOutlet weak var Loai: UITextField!
    @IBOutlet weak var TenPhong: UITextField!

    var phong:Phong!;
    var mode_add=false;
    override func viewWillDisappear(_ animated: Bool) {
        deregisterKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        setdayDefault()
        SavedataButton.isHidden=false;
        SavedataButton.isEnabled=true ;
        registerKeyboardNotifications()
        UI.addDoneButtonForTextField(controls: [self.cmnd, self.Gia, self.TenPhong, self.sucChua,self.Loai,self.SDT, self.HoTen])
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor=UIColor.darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SavedataButton)
        
        if(!mode_add){
            SavedataButton.isHidden=true;
            SavedataButton.isEnabled=false;
            TenPhong.text=phong.maphong;
            Loai.text=(phong.loaiphong as NSNumber).stringValue
            sucChua.text=(phong.succhua as NSNumber).stringValue
            Gia.text=(phong.giaphong as NSNumber).stringValue
        }
        else{
            self.HoTen.isEnabled=false
            self.cmnd.isEnabled=false
            self.button_Ngaydatphong.isEnabled=false
            self.button_Ngaysinh.isEnabled=false
            self.SDT.isEnabled=false
            self.btn_xacNhan.isEnabled=false
            self.GioiTinh.isEnabled=false
            self.check_btn.isHidden=true;
            self.LoaiKH.isEnabled=false
            
        }
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            if(value != nil){
                let value2=value as! Dictionary<String, AnyObject>
                let value3 = value2["BILL"];
                if(value3 != nil){
                    let data = value3 as! Dictionary<String, AnyObject>
                    for i in data{
                        let t = i.value as! Dictionary<String, AnyObject>
                        let max=t["MABILL"] as! String
                        let e = (String(max[max.index(max.startIndex, offsetBy: 1)...]) as NSString).integerValue
                        if(e>self.mabill){
                            self.mabill=e;
                        }
                    }
                    self.mabill=self.mabill+1;
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var thongtinKH: UILabel!
    @IBOutlet weak var CMND_lb: UILabel!
    
    
     @IBOutlet weak var check_btn: UIButton!
     // MARK: - Navigation

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
