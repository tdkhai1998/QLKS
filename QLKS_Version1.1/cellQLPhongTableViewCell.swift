//
//  cellQLPhongTableViewCell.swift
//  QLKhachSan
//
//  Created by Lê Xuân Kha on 12/11/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class cellQLPhongTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblPhong: UILabel!
    @IBOutlet weak var lblLoaiPhong: UILabel!
    @IBOutlet weak var lbsucChua: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setcolor( color: UIColor ){
        self.backgroundColor=UIColor.green
    }
    func setData(_ data: (String, String, String)){
        lblPhong.text=data.0
        lblLoaiPhong.text=data.1
        lbsucChua.text=data.2
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
