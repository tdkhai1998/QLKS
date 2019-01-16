//
//  DoAn_TableViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class DoAn_TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, reData{
    
    
    func passData(_ id: String,_ ten:String,_ gia:String){
        tenDoAn.append(ten)
        maThucPham.append(id)
        donGia.append(Int(gia)!)
        DoAnTable.reloadData()
    }
    
    var c = false
    var tenDoAn: [String] = []
    var donGia: [Int] = []
    var maThucPham: [String] = []
    var passID = ""
    var passFoodName = ""
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maThucPham.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "DoAnCell", for: indexPath) as! DoAnCell
      
        cell.ID.text = maThucPham[indexPath.row]
        cell.tenDoAn.text = tenDoAn[indexPath.row]
        cell.donGia.text = String(donGia[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passID = maThucPham[indexPath.row]
        passFoodName = tenDoAn[indexPath.row]
        performSegue(withIdentifier: "capNhatDonGia", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var ref : DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
      
        if editingStyle == .delete {
          
            ref.child("users/\(userID!)/FOOD").child(maThucPham[indexPath.row]).removeValue();           DispatchQueue.main.async {
                self.DoAnTable.reloadData()
            }
            tenDoAn.remove(at: indexPath.row)
            maThucPham.remove(at: indexPath.row)
            donGia.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier == "capNhatDonGia"){
        let destination = segue.destination as! DoAn_CapNhatViewController
        destination.temp = passFoodName
        destination.id = passID
        }
        if( segue.identifier == "ThemDoAn"){
            let destination = segue.destination as! DoAn_Them_ViewController
            destination.delegate = self
        }
    }


    @IBOutlet weak var DoAnTable: UITableView!
func loadData(){
    var ref : DatabaseReference!
    
    ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    ref.child("users").child(userID!).child("FOOD").observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        
        let value = snapshot.value as? NSDictionary
        if (value == nil)
        {
            let alertController = UIAlertController(title: "Thông Báo", message: "Chưa có thực phẩm", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        for (_,j) in value!{
            self.maThucPham.append((j as AnyObject).value(forKey: "MATHUCPHAM") as! String)
            self.tenDoAn.append((j as AnyObject).value(forKey: "TENTHUCPHAM") as! String)
            self.donGia.append((j as AnyObject).value(forKey: "GIA") as! Int)
        }
        DispatchQueue.main.async {
            self.DoAnTable.reloadData()
        }
        // ...
    }) { (error) in
        print(error.localizedDescription)
    }     // Initialization code
    // Do any additional setup after loading the view.
    DoAnTable.reloadData()
    
}
    override func viewDidLoad() {
       super.viewDidLoad()
        DoAnTable.delegate = self
        DoAnTable.dataSource = self
        loadData()
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
