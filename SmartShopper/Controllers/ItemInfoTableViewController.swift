//
//  ItemInfoTableViewController.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 12/30/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class ItemInfoTableViewController: UITableViewController, UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    var item : Item = Item()
    var editingMode = false
    private var _inputView: UIView?
    override var inputView: UIView? {
        get {
            return _inputView
        }
        set {
            _inputView = newValue
        }
    }
    
    @IBOutlet weak var addUpdateItemButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var tags: UITextField!
    
    var cellArray : [StoreAisleCellTableViewCell] = []
    
    @IBOutlet weak var cell1: StoreAisleCellTableViewCell!
    @IBOutlet weak var cell2: StoreAisleCellTableViewCell!
    @IBOutlet weak var cell3: StoreAisleCellTableViewCell!
    @IBOutlet weak var cell4: StoreAisleCellTableViewCell!
    @IBOutlet weak var cell5: StoreAisleCellTableViewCell!
    
    public func setItem(_ item: Item){
        self.item = item
        editingMode = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "background_food.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        
        if (!editingMode) {
            addUpdateItemButton.setTitle("Add Item", for: .normal)
        } else {
            addUpdateItemButton.setTitle("Update Item", for: .normal)
        }
        
        name.delegate = self
        amount.delegate = self
        brand.delegate = self
        category.delegate = self
        tags.delegate = self
        
        setItemFields()
        cellArray.append(cell1)
        cellArray.append(cell2)
        cellArray.append(cell3)
        cellArray.append(cell4)
        cellArray.append(cell5)
        
        var stores = DataHolder.stores
        for index in 0...((cellArray.count)-1) {
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ItemInfoTableViewController.handleTapAdd(_:)))
            tap.delegate = self
            
            let storeNameField = cellArray[index].getStoreName()
            storeNameField.delegate = self
            let aisleField = cellArray[index].getAisleNum()
            aisleField.delegate = self
            let plusButton = cellArray[index].getPlusButton()
            
            plusButton.addGestureRecognizer(tap)
            plusButton.isUserInteractionEnabled = true
            if stores.count > index {
                storeNameField.text = stores[index]
                if item.storeAisles[stores[index]] != nil {
                    aisleField.text = "\(item.storeAisles[stores[index]]!)"
                }
                storeNameField.isEnabled = false
                plusButton.isHidden = true
            } else if index == stores.count {
                storeNameField.isHidden = true
                aisleField.isHidden = true
            } else {
                storeNameField.isHidden = true
                aisleField.isHidden = true
                plusButton.isHidden = true
            }
        }
    }
    
    private func setItemFields(){
        self.name.text = item.name
        self.amount.text = item.amount
        self.brand.text = item.brand
        self.category.text = item.category
        self.tags.text = item.tagToString(item.tags)
    }
    
    @objc func handleTapAdd(_ sender: UITapGestureRecognizer) {
        var tappedElementFound = false
        for index in 0...cellArray.count-1 {
            let view = cellArray[index].contentView.subviews[2]
            if view == sender.view {
                tappedElementFound = true
                cellArray[index].contentView.subviews[0].isHidden = false
                cellArray[index].contentView.subviews[1].isHidden = false
                cellArray[index].contentView.subviews[2].isHidden = true
            } else if tappedElementFound {
                tappedElementFound = false
                cellArray[index].contentView.subviews[2].isHidden = false
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        //set item data and add any stores if necessary
        populateItem()
        if (!validateItem()){
            return
        }
        
        for index in 0...((cellArray.count)-1) {
            if let storeName = cellArray[index].getStoreName().text {
                if let aisleNumber = Int((cellArray[index].getAisleNum().text)!) {
                    item.updateStoreAisles(storeName, aisle: aisleNumber)
                }
                DataHolder.addStore(storeName)
            }
        }
        
        //add item to dataholder
        if (editingMode && !DataHolder.items.contains(item)){
            //do nothing
        } else {
            DataHolder.addItem(item)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validateItem() -> Bool{
        if (item.name == ""){
            Notification.displayError(view: self.view, text: "Give the item a name")
            return false
        }
        if (DataHolder.items.contains(item) && !editingMode){
            Notification.displayError(view: self.view, text: "You already added this item")
            return false
        }
        return true
    }
    
    private func populateItem(){
        self.item.name = self.name.text!
        self.item.amount = self.amount.text!
        self.item.brand = self.brand.text!
        self.item.category  = self.category.text!
        let tagArray = self.tags.text!.components(separatedBy: ",")
        for tag in tagArray {
            if (tag != "") {
                self.item.addTag(tag)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
