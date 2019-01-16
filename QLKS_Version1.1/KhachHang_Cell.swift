//
//  khachhangCell.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class KhachHangCell: UITableViewCell {
    

    
    @IBOutlet weak var tenKH: UILabel!
    
    @IBOutlet weak var ngaysinhKH: UILabel!
    
    @IBOutlet weak var cmndKH: UILabel!
    @IBOutlet weak var sodtKH: UILabel!
    
    @IBOutlet weak var gtKH: UILabel!
    
    @IBOutlet weak var loaiKH: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
