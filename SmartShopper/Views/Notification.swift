//
//  Notification.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 9/9/18.
//  Copyright © 2018 Samuel Hobel. All rights reserved.
//

import Foundation
import EasyToast

class Notification {
    
    public static func displayNotification(view: UIView, text: String){
        view.showToast(text, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    public static func displayError(view: UIView, text:String, bottom: Bool = true){
        view.toastBackgroundColor = UIColor.red.withAlphaComponent(0.7)
        if (bottom) {
            view.showToast(text, position: .bottom, popTime: 3, dismissOnTap: true)
        } else {
            view.showToast(text, position: .top, popTime: 3, dismissOnTap: true)
        }
    }
}
