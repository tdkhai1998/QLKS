//
//  DoAnCell.swift
//  QLKS_Version1.1
//
//  Created by Lê Xuân Kha on 12/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class DoAnCell: UITableViewCell {

    @IBOutlet weak var DoAnImage: UIImageView!
    @IBOutlet weak var tenDoAn: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var donGia: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
