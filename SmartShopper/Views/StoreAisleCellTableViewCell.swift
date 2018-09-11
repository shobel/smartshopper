//
//  StoreAisleCellTableViewCell.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 9/7/18.
//  Copyright © 2018 Samuel Hobel. All rights reserved.
//

import UIKit

class StoreAisleCellTableViewCell: UITableViewCell {

    private var contentMap = [
        "storeName": 0,
        "aisleNum": 1,
        "plusButton": 2
         ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func getStoreName() -> UITextField {
        return contentView.subviews[contentMap["storeName"]!] as! UITextField
    }
    
    public func getAisleNum() -> UITextField {
        return contentView.subviews[contentMap["aisleNum"]!] as! UITextField
    }
    
    public func getPlusButton() -> UIImageView {
        return contentView.subviews[contentMap["plusButton"]!] as! UIImageView
    }

}
