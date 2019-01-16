//
//  HoaDon.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import FirebaseAuth

import CoreData
class HoaDon: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_thucAn.count;
    }
    var gia=0;
    var delegate:thanhToan!;
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView_hoaDon.dequeueReusableCell(withIdentifier: "hoaDonCell")! as! HoaDonCell
        cell.TenThucAn.text=arr_thucAn[indexPath.row].2;
        cell.SoLuong.text=(arr_thucAn[indexPath.row].1 as NSNumber).stringValue
          let tt=arr_thucAn[indexPath.row].1*arr_thucAn[indexPath.row].3;
        tien=tien+tt;
        cell.ThanhTien.text=(tt as NSNumber).stringValue
        tbTongTien.text=(tien as NSNumber).stringValue
        return cell;
    }
     let dateFormatter = DateFormatter()
    var tien=0;
    var tienphong=0;
    override func viewDidLoad() {
        super.viewDidLoad()
        tableThucAn.delegate=self
        tableThucAn.dataSource=self
        tableThucAn.reloadData()
       
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        let d=dateFormatter.date(from: bill!.CheckInTime);
        let a=d!.timeIntervalSinceNow
        let b = Int(-1*round(a/3600))+1
        
        self.lbSoHoaDon.text="Số: "+bill.maBill
        self.lbNgayVao.text="Giờ vào: "+bill.CheckInTime
        self.lbNgayRa.text="Giờ ra : "+dateFormatter.string(from: Date())
        self.lbTenPhong.text="Phòng: "+bill.maPhong
        
        
        tienphong=b*bill.gia
        tien=tienphong
        self.tienPhong.text="Tiền phòng: "+(tien as NSNumber).stringValue
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var tableThucAn: UITableView!
    @IBOutlet weak var tienPhong: UILabel!
    
    @IBAction func thanhtoan(_ sender: Any) {
         bill.CheckOutTime=self.dateFormatter.string(from:Date())
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        
        
       
        ref.child("users").child(userID!).child("BILL/"+self.bill.maBill+"/CHECKOUT_TIME").setValue(dateFormatter.string(from: Date()));
        ref.child("users").child(userID!).child("BILL/"+self.bill.maBill+"/SERVICE_FEE").setValue(tien-tienphong);
         ref.child("users").child(userID!).child("BILL/"+self.bill.maBill+"/TOTAL").setValue(tien);
        ref.child("users").child(userID!).child("PHONG/"+self.bill.maPhong+"/TINHTRANG").setValue("Rảnh");
        ref.child("users").child(userID!).child("BILL/"+self.bill.maBill).observe(.childAdded, with:{(n) in
            let alertController = UIAlertController(title: "Thông Báo", message: "Thanh Toán Thành công!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler:
            { (n) in
                self.delegate.DaThanhToan();
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
    }
    var bill:Bill!;
    var arr_thucAn:[(String,Int,String,Int)] = []
    @IBOutlet weak var btThanhToan: UIButton!
    @IBOutlet weak var tbTongTien: UITextField!
    @IBOutlet weak var lbTenPhong: UILabel!
    @IBOutlet weak var lbThuNgan: UILabel!
    @IBOutlet weak var lbNgayRa: UILabel!
    @IBOutlet weak var lbNgayVao: UILabel!
    @IBOutlet weak var lbSoHoaDon: UILabel!
    @IBOutlet weak var tableView_hoaDon: UITableView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
