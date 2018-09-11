//
//  ShoppingListTabBarController.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 9/7/18.
//  Copyright © 2018 Samuel Hobel. All rights reserved.
//

import UIKit

class ShoppingListTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ShoppingListViewController
        if dest.restorationIdentifier == Constants.fullShoppingList {
            dest.setItems(DataHolder.items)
        } else {
            dest.setItems(DataHolder.currentShoppingList)
        }
    }

}
