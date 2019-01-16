//
//  ThongKe_DoanhThu_LuotKhach_ViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 1/14/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
import Charts
class ThongKe_TB_ViewController: UIViewController {
    var ondinh = PieChartDataEntry(value: 0)
    var dangsuachua = PieChartDataEntry(value: 0)
    var huhong = PieChartDataEntry(value: 0)
    var number = [PieChartDataEntry]()
    var dem : (Int, Int, Int) = (0,0,0)
    @IBOutlet weak var pieChart: PieChartView!
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
                let temp = (j as AnyObject).value(forKey: "TINHTRANG") as! String
               
                if (temp == "Ổn định"){
                    self.dem.0 = self.dem.0 + 1
                }
                if (temp == "Đang sửa chữa"){
                    self.dem.1 = self.dem.1 + 1
                }
                if (temp == "Hư hỏng")
                {
                    self.dem.2 = self.dem.2 + 1
                }
       
            }
            DispatchQueue.main.async {
                self.pieChart.chartDescription?.text = "Tình hình thiết bị"
                
                self.ondinh.value = Double(self.dem.0)
                self.dangsuachua.value = Double(self.dem.1)
                self.huhong.value = Double(self.dem.2)
                
                self.ondinh.label = "Ổn định"
                self.huhong.label = "Hư hỏng"
                self.dangsuachua.label = "Đang sửa chữa"
                self.number = [self.ondinh, self.dangsuachua, self.huhong]
                self.udateChartData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }     }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    func udateChartData(){
        let dataSet = PieChartDataSet(values: number, label: nil)
        let pieData = PieChartData(dataSet: dataSet)
        
        let color = [UIColor.green,UIColor.yellow, UIColor.red]
        dataSet.colors = color as [NSUIColor]
        pieChart.data = pieData
        
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
