//
//  CellPhongKhongTrong.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 1/12/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CellPhongKhongTrong: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var tenThucAn: UILabel!
    @IBOutlet weak var soLuong: UILabel!
    @IBOutlet weak var giaThucAn: UILabel!
}
