//
//  PhongKhongTrongViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
protocol thanhToan{
    func DaThanhToan();
}
class Bill{
    var maBill:String!="";
    var maPhong: String! = "";
    var maKhachHang: String!=""
    var CheckInTime: String!=""
    var CheckOutTime: String=""
    var fee:Int = 0;
    var gia=0;
}
protocol  capNhatThanhToan{
    func ThanhToanRoiNha();
}
class PhongKhongTrongViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, ThucAn, thanhToan{
    func DaThanhToan() {
        self.navigationController?.popViewController(animated: true)
        self.thanhToanRoiA.ThanhToanRoiNha()
    }
    var thanhToanRoiA:capNhatThanhToan!;

    
    
    func datThucAn(_ data: [(String, Int,String, Int)]) {
        let len=arr_thucAn.count
        for i in data{
            if(i.1 != 0){
                var check=true;
                for j in 0..<len{
                    if(i.0==arr_thucAn[j].0){
                        arr_thucAn[j].1=i.1;
                        order(j)
                        check=false;
                        break;
                    }
                }
                if(check){
                    arr_thucAn.append(i)
                    order(arr_thucAn.count-1)
                }
            }
        }
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("DATTHUCPHAM").observe( .childAdded, with: {(snapshot)->Void in
            let alertController = UIAlertController(title: "Thông Báo", message: "Order Thành công!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler:nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
        tableView_thucAn.reloadData()
        }
    
    var arr_thucAn:[(String,Int,String, Int)] = []
    var phong:Phong!;
    var bill: Bill=Bill();
    func order(_ j:Int){
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let a=["MABILL": self.bill.maBill,"TENTHUCPHAM": arr_thucAn[j].2,  "MATHUCPHAM": arr_thucAn[j].0, "SOLUONG": arr_thucAn[j].1, "GIA":arr_thucAn[j].3] as [String : Any]
        ref.child("users").child(userID!).child("DATTHUCPHAM/ORDER"+self.bill.maBill+(j as NSNumber).stringValue).setValue(a);
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_thucAn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView_thucAn.dequeueReusableCell(withIdentifier: "cell_phongKhongTrong")! as! CellPhongKhongTrong
        cell.tenThucAn.text=arr_thucAn[indexPath.row].2;
        cell.soLuong.text=(arr_thucAn[indexPath.row].1 as NSNumber).stringValue;
        cell.giaThucAn.text=(arr_thucAn[indexPath.row].3 as NSNumber).stringValue;
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue_themThucAn"){
            let view = segue.destination as! ThemThucAn
            view.delegate=self;
            view.thucAnDaDat = self.arr_thucAn;
        }
        else if(segue.identifier == "segue_thanhtoan"){
             let view = segue.destination as! HoaDon
             view.bill=self.bill;
            view.delegate=self
            view.arr_thucAn=self.arr_thucAn
            view.bill=self.bill
        }
    }
    
    
    
    
    @IBOutlet weak var loaiPhong: UILabel!
    @IBOutlet weak var tenKhachHang: UILabel!
    @IBOutlet weak var maPhong_label: UILabel!
    @IBOutlet weak var thanhToanButton: UIButton!
    @IBOutlet weak var edit_button: UIButton!
    @IBOutlet weak var tableView_thucAn: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableView_thucAn.setEditing(tr/, animated: true)
        tableView_thucAn.dataSource=self;
        tableView_thucAn.delegate=self;
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: edit_button)
        self.navigationItem.titleView=thanhToanButton
        // Do any additional setup after loading the view.
        self.maPhong_label.text=phong.maphong
        tenKhachHang.text="Khách Hàng: "+(phong.khachhang as NSNumber).stringValue;
        loaiPhong.text="Loại Phòng: "+(phong.loaiphong as NSNumber).stringValue;

        
        
        
        
       
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in

            var maBill:String!=""
            let value = snapshot.value as? Dictionary<String, AnyObject>
            let bill=value!["BILL"] as! Dictionary<String, AnyObject>
            for i in bill{
                let data=i.value as! NSDictionary
                if (self.phong.maphong==data["PHONG"] as!String)&&((data["CHECKOUT_TIME"] as! String)=="NULL"){
                    self.bill.maBill=(data["MABILL"] as! String);
                    self.bill.maPhong=self.phong.maphong;
                    self.bill.maKhachHang=(data["KHACHHANG"] as! NSNumber).stringValue;
                    self.bill.CheckInTime=(data["CHECKIN_TIME"] as! String)
                    self.bill.gia=(data["DONGIA"] as! Int)
                    maBill=i.key;
                    break;
                }
            }
              let datThucAn=value?["DATTHUCPHAM"] ;
                if (datThucAn != nil){
                for i in datThucAn as! [String:AnyObject]{
                    let data=i.value as! NSDictionary
                    print(data)
                    if(data["MABILL"] as! String)==maBill{
                        let tenThucAn=data["MATHUCPHAM"] as! String;
                        let soLuong=data["SOLUONG"] as! Int;
                        let ten=data["TENTHUCPHAM"] as! String;
                        let gia=data["GIA"] as! Int
                        self.arr_thucAn.append((tenThucAn,soLuong,ten,gia));
                    }
                }
            }
            self.tableView_thucAn.reloadData();
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

