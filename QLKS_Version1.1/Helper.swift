//
//  Helper.swift
//  FlashLight
//
//  Created by Lê Xuân Kha on 10/18/18.
//  Copyright © 2018 Lê Xuân Kha. All rights reserved.
//

import UIKit

class UI {
    static func addDoneButtonForTextField(controls: [UITextField]) {
        for textField in controls {
            let toolbar = UIToolbar()
            toolbar.items = [
                //thêm một item của toolbar, là khoảng trắng linh động
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder))
            ]
            toolbar.sizeToFit()
            textField.inputAccessoryView = toolbar
        }
    }
}
