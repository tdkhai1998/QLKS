//
//  QuanLyKH_ViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//
import Firebase
import FirebaseAuth
import CoreData
import UIKit

class KhachHang_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, passDataKH {
    
    @IBOutlet weak var khachhangTable: UITableView!
    
    
    var index = 0
    var tenKH : [String] = []
    var loaiKH : [String] = []
    var ngaysinhKH: [String] = []
    var sodtKH: [String] = []
    var cmndKH: [String] = []
    var gioitinhKH: [String] = []
    func reloadData(_ ten: String,_ ngaysinh: String, _ sodt: String, _ cmnd: String, _ gioitinh: String, _ row: Int ){
        if( row == -1 )
        {
        self.tenKH.append(ten)
        self.cmndKH.append(cmnd)
        self.sodtKH.append(sodt)
        self.loaiKH.append("Bạc")
        self.ngaysinhKH.append(ngaysinh)
        self.gioitinhKH.append(gioitinh)
        }
        else
        {
            tenKH[row] = ten
            cmndKH[row] = cmnd
            sodtKH[row] = sodt
            ngaysinhKH[row] = ngaysinh
            gioitinhKH[row] = gioitinh
        }
        khachhangTable.reloadData()
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmndKH.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KhachHangCell", for: indexPath) as! KhachHangCell
        
     
        
        cell.tenKH.text = tenKH[indexPath.row]
        cell.loaiKH.text = loaiKH[indexPath.row]
        cell.gtKH.text = gioitinhKH[indexPath.row]
        cell.ngaysinhKH.text = ngaysinhKH[indexPath.row]
        cell.sodtKH.text = sodtKH[indexPath.row]
        cell.cmndKH.text = cmndKH[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "edit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! KhachHang_Them_Viewcontroller
        if segue.identifier == "add"{
            destination.mode = -1
            destination.delegate = self
            destination.btnLabel = "Thêm"
        }
        else if segue.identifier == "edit"
        {
            destination.delegate = self
            destination.mode = index
           destination.btnLabel = "Cập nhật"
            destination.data1 = tenKH[index]
            destination.data2 = ngaysinhKH[index]
            destination.data3 = cmndKH[index]
            destination.data4 = sodtKH[index]
            if (gioitinhKH[index] == "Nam"){
                 destination.data5 = 0
            }
            else
            {
                 destination.data5 = 1
            }
            
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        if editingStyle == .delete {
            
            ref.child("users/\(userID!)/KHACHHANG").child(cmndKH[indexPath.row]).removeValue();           DispatchQueue.main.async {
                self.khachhangTable.reloadData()
            }
           tenKH.remove(at: indexPath.row)
           loaiKH.remove(at: indexPath.row)
            gioitinhKH.remove(at: indexPath.row)
            sodtKH.remove(at: indexPath.row)
           ngaysinhKH.remove(at: indexPath.row)
            cmndKH.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
         let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).child("KHACHHANG").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                let alertController = UIAlertController(title: "Thông Báo", message: "Chưa có khách hàng", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            for (_,j) in value!{
                self.tenKH.append((j as AnyObject).value(forKey: "TENKH") as! String)
                self.cmndKH.append((j as AnyObject).value(forKey:"CMND") as! String)
                self.loaiKH.append((j as AnyObject).value(forKey: "LOAIKH") as! String)
                 self.sodtKH.append((j as AnyObject).value(forKey: "SODIENTHOAI") as! String)
                 self.ngaysinhKH.append((j as AnyObject).value(forKey: "NGAYSINH") as! String)
                 self.gioitinhKH.append((j as AnyObject).value(forKey: "GIOITINH") as! String)
            }
            DispatchQueue.main.async {
                self.khachhangTable.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     // Initialization code        // Do any additional setup after loading the view.
    }
    

   

   

        // Configure the view for the selected state
    

}
