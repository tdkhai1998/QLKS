//
//  ViewController.swift
//  QLKS_QLITBI
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class ThietBi_Phong_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var ThietBi_Phong_collection: UICollectionView!
    var index = 0
    var maPhong: [String] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maPhong.count
 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        cell.RoomID.text = String(maPhong[indexPath.row])
        cell.myIMG.image = UIImage(named: "door.png")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail")
        {
            let destination = segue.destination as! ThietBi_ChiTiet_TableViewController
            destination.phongHienTai = maPhong[index]
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       ThietBi_Phong_collection.dataSource = self
        ThietBi_Phong_collection.delegate = self
        
       
        
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
                self.maPhong.append((j as AnyObject).value(forKey: "MAPHONG") as! String)
                
            }
            DispatchQueue.main.async {
                self.ThietBi_Phong_collection.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     // Initialization code
        // Do any additional setup after loading the views

    }
}

