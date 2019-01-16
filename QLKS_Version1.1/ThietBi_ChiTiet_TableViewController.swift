//
//  ThietBi_ChiTiet_TableViewController.swift
//  QLKS_QLITBI
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class ThietBi_ChiTiet_TableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, updateStatus {
 

    func setStatus(_ tt: String, _ index: Int) {
        tinhtrangTB[index] = tt
        ThietBi_TableView.reloadData()
    }
    
    var phongHienTai = ""
    var maTB :[String] = []
    var tenTB: [String] = []
    var tinhtrangTB:[String] = []
    var index = 0

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maTB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! myTableViewCell
        cell.ID.text = maTB[indexPath.row]
        cell.TenThietBi.text = tenTB[indexPath.row]
        cell.TinhTrang.text = tinhtrangTB[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        if editingStyle == .delete {
            
            ref.child("users/\(userID!)/THIETBI").child(maTB[indexPath.row]).removeValue();           DispatchQueue.main.async {
                self.ThietBi_TableView.reloadData()
            }
            maTB.remove(at: indexPath.row)
            tenTB.remove(at: indexPath.row)
            tinhtrangTB.remove(at: indexPath.row)
            ThietBi_TableView.deleteRows(at: [indexPath], with: .automatic)
        }
       
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.ThietBi_TableView.isEditing = !self.ThietBi_TableView.isEditing
        sender.title = (self.ThietBi_TableView.isEditing) ? "Done" : "Edit"    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "capNhat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "capNhat"){
        let destination = segue.destination as! ThietBi_CapNhat_ViewController
            destination.ttTB = tinhtrangTB[index]
            destination.tenTB = tenTB[index]
            destination.maTB = maTB[index]
            destination.phong = phongHienTai
            destination.index = index
            destination.delegate =  self
        }
    }
    func loadData()
    {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).child("THIETBI").observeSingleEvent(of: .value, with: { (snapshot) in
   
            let value = snapshot.value as? NSDictionary
            if (value == nil)
            {
                let alertController = UIAlertController(title: "Thông Báo", message: "Chưa có thiết bị", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            for (_,j) in value!{
                let temp = (j as AnyObject).value(forKey: "PHONG") as! String
                if (temp == self.phongHienTai){
                    self.maTB.append((j as AnyObject).value(forKey: "MATHIETBI") as! String)
                    self.tenTB.append((j as AnyObject).value(forKey: "TENTHIETBI") as! String)
                    self.tinhtrangTB.append((j as AnyObject).value(forKey: "TINHTRANG") as! String)
                }
            }
            DispatchQueue.main.async {
                self.ThietBi_TableView.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     }
    @IBOutlet weak var ThietBi_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
ThietBi_TableView.delegate = self
        ThietBi_TableView.dataSource = self
      
        loadData()
        print(phongHienTai)
        // Do any additional setup after loading the view.
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
