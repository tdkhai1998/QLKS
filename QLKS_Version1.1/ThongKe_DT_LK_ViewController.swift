//
//  ThongKe_TB_ViewController.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 1/14/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Charts

import Firebase
import FirebaseAuth
import CoreData

class ThongKe_DoanhThu_LuotKhach_ViewController: UIViewController {


    var lineChartEntry1 = [ChartDataEntry]()
    var lineChartEntry2 = [ChartDataEntry]()
    //select xong cho vô 2 mảng bên dướii là đc, đây là giá trị cột y, cột x xem bên dưới chartDataEntry"
    var luotkhach: [Int] = Array(repeating: 0, count: 13)
    var doanhthu: [Float] =  Array(repeating: 0.0, count: 13)
    
    func loadData(){
        for i in 0 ..< luotkhach.count
        {
            let value = ChartDataEntry(x: Double(i), y: Double(luotkhach[i]))
            lineChartEntry1.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry1, label: "Lượt khách")
        line1.colors = [UIColor.red]
        let data = LineChartData()
        data.addDataSet(line1)
        
        for i in 0 ..< doanhthu.count
        {
            let value = ChartDataEntry(x: Double(i), y: Double(doanhthu[i]))
            lineChartEntry2.append(value)
        }
        let line2 = LineChartDataSet(values: lineChartEntry2, label: "Doanh thu")
        line2.colors = [UIColor.blue]
        data.addDataSet(line2)
        
        lineChart.data = data
        lineChart.chartDescription?.text = "Thống kê doanh thu - lượt khách"
    }
    @IBOutlet weak var lineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value
            if(value != nil){
                let value2=value as! Dictionary<String, AnyObject>
                let value3 = value2["BILL"];
                if(value3 != nil){
                    let bills=value3 as! Dictionary<String,AnyObject>;
                    for i in bills{
                        let data=i.value as! Dictionary<String,AnyObject>
                        let checkin_time=data["CHECKIN_TIME"] as! String
                        let thang_str=checkin_time[checkin_time.startIndex..<checkin_time.index(checkin_time.startIndex, offsetBy: 2)]
                        let thang_int=(thang_str as NSString).integerValue;
                        self.luotkhach[thang_int] += 1
                        self.doanhthu[thang_int] += (data["TOTAL"] as! Float)/100000.0
                    }
                  self.loadData()
                }
            }
        })
        
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
