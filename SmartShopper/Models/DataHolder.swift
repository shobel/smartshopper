//
//  DataHolder.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 12/24/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation
import UIKit

class DataHolder {
    
    public static var stores : [String] = []
    public static var items : [Item] = []
    public static var currentShoppingList : [Item] = []
    public static var shoppingMode = false
    public static var shoppingAt = ""
    public static var shouldCheckStores = true
    
    public static func getFile(objectName: String) -> String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent(objectName).path)
    }
    
    public static func addStore(_ store: String){
        if (!self.stores.contains(store) && store != ""){
            stores.append(store)
        }
    }
    
    public static func addItem(_ item: Item){
        if (self.items.contains(item)){
            items.remove(at: items.index(of: item)!)
        }
        items.append(item)
        items.sort(by: sortListByName(_:item2:))
    }
    
    public static func addToCurrentShoppingList(_ item: Item){
        currentShoppingList.append(item)
        currentShoppingList.sort(by: sortListByName(_:item2:))
    }
    
    public static func sortListByAisle(_ forStore: String){
        currentShoppingList.sort(by: {
            if ($0.storeAisles[forStore] != nil && $1.storeAisles[forStore] != nil){
                return $0.storeAisles[forStore]! < $1.storeAisles[forStore]!
            }
            if ($0.category != "" && $1.category != ""){
                return $0.category < $0.category
            }
            return $0.name < $1.name
        })
    }
    
    private static func sortListByName(_ item1: Item, item2: Item) -> Bool {
        return item1.name < item2.name
    }
    
    public static func saveData(){
        NSKeyedArchiver.archiveRootObject(items, toFile: getFile(objectName: "fullList"))
        NSKeyedArchiver.archiveRootObject(currentShoppingList, toFile: getFile(objectName: "shoppingList"))
        NSKeyedArchiver.archiveRootObject(stores, toFile: getFile(objectName: "stores"))
    }
    
    public static func loadData(){
        if let items = NSKeyedUnarchiver.unarchiveObject(withFile: getFile(objectName: "fullList")) {
            self.items = items as! [Item]
        }
        if let currentList = NSKeyedUnarchiver.unarchiveObject(withFile: getFile(objectName: "shoppingList")) {
            self.currentShoppingList = currentList as! [Item]
        }
        if let stores = NSKeyedUnarchiver.unarchiveObject(withFile: getFile(objectName: "stores")) {
            self.stores = stores as! [String]
        }
    }
}
