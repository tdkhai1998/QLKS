//
//  ThemThucAn.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

protocol ThucAn{
    func datThucAn(_ data: [(String,Int, String, Int)]);
}
class ThemThucAn: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ThemThucAn_cell=tableView_thucAn.dequeueReusableCell(withIdentifier: "cell_themThucAn")! as! ThemThucAn_cell
        cell.getData((arr[indexPath.row].2,arr[indexPath.row].1) )
        return cell
    }
    
    var arr:[(String, Int, String,Int)]=[]
    // KhaiTD: Outlets
    @IBOutlet weak var button_OK: UIButton!
    @IBOutlet weak var tableView_thucAn: UITableView!
    //KhaiTD Variables
    var delegate:ThucAn!
    var thucAnDaDat:[(String, Int, String, Int)]=[]
    //KhaiTD Actions
    @IBAction func button_touchDown_OK(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        var index=0;
        for i in self.tableView_thucAn.visibleCells{
            let a = i as! ThemThucAn_cell
            arr[index].1=a.data.1
            index=index+1;
        }
        delegate.datThucAn(arr);
    }
    /*func query_select(select field : [String], from table: String, where condition: (String,String) ) -> Dictionary<String,AnyObject>{
        
        var result: Dictionary<String,AnyObject>!=[:]
        
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? Dictionary<String, AnyObject>
            let table_r = value![table] as! Dictionary<String, AnyObject>
            for i in table_r{
                var dic: Dictionary<String, AnyObject>=[:]
                var data=i.value as! Dictionary<String, AnyObject>
                if(condition==("",""))||(data[condition.0] as! String)==condition.1 {
                    for j in field{
                        dic[j]=data[j] as AnyObject;
                    }
                    result[i.key]=dic as AnyObject
                }
            }
            DispatchQueue.main.async {
                
                return result
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        self.viewDidLoad()
        return result;
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView_thucAn.delegate=self
        self.tableView_thucAn.dataSource=self
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: button_OK)
        // Do any additional setup after loading the view.
      
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
        
            let value = snapshot.value as? Dictionary<String, AnyObject>
            let food = value!["FOOD"] as! NSDictionary
            for i in food{
                
                let data=i.value as! NSDictionary;
                let maThucAn=data["MATHUCPHAM"] as!String
                let tenThucAn=data["TENTHUCPHAM"] as!String
                let gia=data["GIA"] as! Int
                var k:(String,Int,String,Int)!=("",0,"",0);
                for j in self.thucAnDaDat{
                    if maThucAn==j.0{
                        k=j;
                        break;
                    }
                }
                self.arr.append((maThucAn,k.1,tenThucAn,gia))
            }
            
            self.tableView_thucAn.reloadData();
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
