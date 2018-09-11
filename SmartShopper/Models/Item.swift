//
//  Item.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 12/24/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation

class Item: NSObject, NSCoding{

    var name = ""
    var amount = ""
    var brand = ""
    var category = ""
    var tags : [String] = [] //simple list of tags 
    var storeAisles : [String:Int] = [:] //associative array of store -> aisle number
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.brand, forKey: "brand")
        coder.encode(self.category, forKey: "category")
        coder.encode(self.amount, forKey: "amount")
        coder.encode(self.tags, forKey: "tags")
        coder.encode(self.storeAisles, forKey: "storeAisles")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let brand = decoder.decodeObject(forKey: "brand") as? String,
            let category = decoder.decodeObject(forKey: "category") as? String,
            let amount = decoder.decodeObject(forKey: "amount") as? String,
            let tags = decoder.decodeObject(forKey: "tags") as? [String],
            let storeAisles = decoder.decodeObject(forKey: "storeAisles") as? [String:Int]
        else {
            return nil
        }
        self.init(name: name, brand: brand, category: category, amount: amount, tags: tags, storeAisles: storeAisles)
    }
    
    init(name: String, brand: String, category: String, amount: String, tags: [String], storeAisles: [String:Int]){
        self.name = name
        self.brand = brand
        self.category = category
        self.amount = amount
        self.tags = tags
        self.storeAisles = storeAisles
    }
    
    required convenience override init(){
        self.init(name: "", brand: "", category: "", amount: "", tags: [], storeAisles: [:])
    }
    
    public func updateStoreAisles(_ store : String, aisle: Int){
        storeAisles[store] = aisle
    }
    
    public func addTag(_ tag: String){
        tags.append(tag)
    }
    
    public func tagToString(_ tags: [String]) -> String {
        var tagString : String = ""
        if (tags.count == 0) {
            return tagString
        }
        for tag in tags {
            tagString += tag + ","
        }
        tagString.removeLast()
        return tagString
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        if (lhs.name == rhs.name && lhs.brand == rhs.brand){
            return true
        } else {
            return false
        }
    }
    
}
