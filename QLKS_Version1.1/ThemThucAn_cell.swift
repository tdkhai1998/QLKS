//
//  ThemThucAn_cell.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/20/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
class ThemThucAn_cell: UITableViewCell {
     override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if(selected){
            self.backgroundColor=UIColor.gray
        }
        else{
             self.backgroundColor=UIColor.white
        }
    }
    //KhaiTD: Outlets
    @IBOutlet weak var label_tenThucAn: UILabel!
    @IBOutlet weak var textField_soLuong: UITextField!
    @IBOutlet weak var button_tru: UIButton!
    @IBOutlet weak var button_cong: UIButton!
    //KhaiTD: Variables
    var data:(String, Int)!;
    //KhaiTD: Functions
    func getData(_ fdata: (String, Int)){
        data=fdata;
        label_tenThucAn.text=fdata.0;
        textField_soLuong.text=String(fdata.1);
    }
    @IBAction func button_touchDown_tru(_ sender: Any) {
        if(data.1 > 1){
            data.1-=1;
        }
        else{
            data.1=0;
        }
        textField_soLuong.text=String(data.1);
    }
    @IBAction func button_touchDown_cong(_ sender: Any) {
        data.1+=1;
        textField_soLuong.text=String(data.1);
    }
}
