//
//  myTableViewCell.swift
//  QLKS_QLITBI
//
//  Created by Lê Xuân Kha on 12/12/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var TenThietBi: UILabel!
    @IBOutlet weak var TinhTrang: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
