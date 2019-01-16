//
//  QuanlyKhachSan_ViewController.swift
//  QLKhachSan
//
//  Created by Lê Xuân Kha on 12/4/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class Phong{
    var trangthai:Bool!=false;
    var giaphong:Int!=0;
    var khachhang:Int!=0;
    var loaiphong:Int!=0;
    var succhua:Int!=0;
    var maphong:String="";
}


class QuanlyKhachSan_ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, datPhong, capNhatThanhToan{

    
    func themPhongTC(_ p:Phong) {
       dsPhong.append(p)
        table.reloadData()
    }
    
    func ThanhToanRoiNha() {
        dsPhong[index].trangthai=false;
        table.reloadData()
    }
    
    func datThucAn() {
        self.performSegue(withIdentifier: "segue_phongKhongTrong", sender: nil)
        dsPhong[index].trangthai=true;
        table.reloadData()
    }
    
    func datThanhCong() {
        dsPhong[index].trangthai=true;
        table.reloadData()
       
    }
    
    
    
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell_Phong") as! cellQLPhongTableViewCell)
        //cell.contentView.backgroundColor=UIColor.green
        
        cell.setData((self.dsPhong[indexPath.row].maphong  ,(self.dsPhong[indexPath.row].loaiphong! as NSNumber).stringValue,(self.dsPhong[indexPath.row].succhua! as NSNumber).stringValue))
        
        if (dsPhong[indexPath.row].trangthai){
            cell.icon.image=UIImage(named: "red")
            
        }
        else{
            cell.icon.image=UIImage(named: "green")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(dsPhong[indexPath.row].trangthai){
            return false;
        }
        return true;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            var ref:DatabaseReference!
            ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).child("PHONG/"+dsPhong[indexPath.row].maphong).removeValue()

            dsPhong.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .automatic);
            
        }
    }
    var index:Int! = -1;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (dsPhong[indexPath.row].trangthai){
            index=indexPath.row
            performSegue(withIdentifier: "segue_phongKhongTrong", sender: nil)
        }
        else{
            index=indexPath.row
            performSegue(withIdentifier: "segue_phongTrong" , sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dsPhong.count;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="segue_phongKhongTrong"){
            let des=segue.destination as! PhongKhongTrongViewController;
            des.phong=dsPhong[index];
            des.thanhToanRoiA=self;
        }
        else if(segue.identifier=="segue_phongTrong"){
            let des=segue.destination as! PhongTrongViewController;
            des.delegate=self
            des.mode_add=mode_add
            mode_add=false;
            if(index>=0){
                des.phong=dsPhong[index];}
        }
    }
    
    var mode_add=false;
    
    //variables
    var dsPhong:[Phong]=[]
    
    //Outlets
    @IBOutlet weak var ButtonThemPhong: UIButton!
     @IBOutlet weak var table: UITableView!
    
    // Actions
    @IBAction func ButtonThemPhong_TouchDown(_ sender: Any) {
        mode_add=true;
        performSegue(withIdentifier: "segue_phongTrong", sender: nil)
    }
    
   
  
  
   
    
   
    
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    self.table.dataSource = self
    self.table.delegate = self
        self.navigationController?.navigationBar.backgroundColor=UIColor.darkGray
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ButtonThemPhong)
        dsPhong=[]
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            if(value != nil){
                let value2=value as! Dictionary<String, AnyObject>
                let value3 = value2["PHONG"];
                if(value3 != nil){
                    let data = value3 as! Dictionary<String, AnyObject>
                    for i in data{
                        let p=Phong();
                        let data=i.value as! NSDictionary
                        //maphong
                        p.maphong=data["MAPHONG"] as! String;
                        //tinhtrang
                        let a:String=data["TINHTRANG"] as! String;
                        if(a=="Rảnh"){
                            p.trangthai=false;
                        }
                        else{
                            p.trangthai=true;
                        }
                        //loaiphong
                        p.loaiphong=data["LOAIPHONG"] as? Int;
                        //succhua
                        p.succhua=data["SUCCHUA"] as? Int;
                        //khachhang
                        //giaphong
                        p.giaphong=data["GIAPHONG"] as? Int;
                        self.dsPhong.append(p);
                    }
                    self.table.reloadData();
                }
                else{
                    let alertController = UIAlertController(title: "Thông Báo", message: "Không có Phòng, vui lòng thêm Phòng!!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler:
                    {(snap ) in
                        self.mode_add=true;
                         self.performSegue(withIdentifier: "segue_phongTrong", sender: nil)
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
    
    

