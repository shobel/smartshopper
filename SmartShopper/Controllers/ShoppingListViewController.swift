//
//  ShoppingListViewController.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 12/26/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

extension ShoppingListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterList(searchText)
        reloadData(filtering: true)
    }
}

class ShoppingListViewController: UITableViewController {
    
    @IBOutlet weak var startEndShoppingButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isFullList = false
    var items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.restorationIdentifier == Constants.currentShoppingList && DataHolder.shoppingMode){
            if (self.items.count > 0){
                DataHolder.shoppingMode = false
                toggleShoppingMode(DataHolder.shoppingAt)
            }
        }
        setUpSwiping()
        if (self.restorationIdentifier == Constants.currentShoppingList){
            tableView.backgroundView = UIImageView(image: UIImage(named: "green.png"))
        } else {
            tableView.backgroundView = UIImageView(image: UIImage(named: "blue.png"))
        }
        
        if (searchBar != nil) {
            searchBar.autocapitalizationType = .none
            searchBar.delegate = self
        }
    }
    
    private func setUpSwiping(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 2 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        if (startEndShoppingButton != nil){
            if (self.items.count == 0){
                if (DataHolder.shoppingMode){
                    toggleShoppingMode()
                }
                startEndShoppingButton.isHidden = true
            } else {
                startEndShoppingButton.isHidden = false
            }
        }
    }
    
    private func reloadData(filtering: Bool = false){
        if (!filtering){
            if (self.restorationIdentifier == Constants.fullShoppingList){
                self.setItems(DataHolder.items)
                isFullList = true
            } else {
                self.setItems(DataHolder.currentShoppingList)
                isFullList = false
            }
        }
        self.tableView.reloadData()
    }
    
    public func setItems(_ items: [Item]){
        self.items = items
    }
    
    public func setItems(_ shoppingAt: String) {
        DataHolder.shoppingAt = shoppingAt
        toggleShoppingMode(shoppingAt)
    }
    
    private func toggleShoppingMode(_ store: String = "Shopping List"){
        DataHolder.shoppingMode = !DataHolder.shoppingMode
        if (DataHolder.shoppingMode){
            startEndShoppingButton.setTitle("Finish Shopping at " + store, for: .normal)
            DataHolder.sortListByAisle(store)
        } else {
            startEndShoppingButton.setTitle("Start Shopping", for: .normal)
        }
        reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListItem", for: indexPath)
        let item = self.items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.brand
        let rightLabel = UILabel.init(frame: CGRect(x:0,y:0,width:200,height:20))
        rightLabel.textAlignment = .right;
        rightLabel.text = item.amount
        cell.accessoryView = rightLabel
        
        if (self.restorationIdentifier == Constants.currentShoppingList && DataHolder.shoppingMode){
            if (item.amount != ""){
                cell.textLabel?.text = item.name + " (" + item.amount + ")"
            } else {
                cell.textLabel?.text = item.name
            }
            
            if (DataHolder.shoppingAt != "" && (item.storeAisles[DataHolder.shoppingAt] != nil)){
                rightLabel.text = "Aisle " + "\(item.storeAisles[DataHolder.shoppingAt]!)"
            } else {
                rightLabel.text = "No Aisle Info"
            }
        }
        cell.layer.backgroundColor = UIColor(white: 1, alpha: 0.5).cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let itemName = self.items[indexPath.row].name
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            var message = ""
            if (self.isFullList){
                message = itemName + " removed"
                DataHolder.items.remove(at: indexPath.row)
            } else {
                message = itemName + " moved to full list"
                DataHolder.items.append(self.items[indexPath.row])
                DataHolder.currentShoppingList.remove(at: indexPath.row)
            }
            self.reloadData()
            Notification.displayNotification(view: self.view, text: message)
        }
        
        var actions = [remove]
        if (isFullList) {
            let add = UITableViewRowAction(style: .normal, title: "Add") { (action, indexPath) in
                let message = itemName + " added to shopping list"
                DataHolder.addToCurrentShoppingList(DataHolder.items[indexPath.row])
                DataHolder.items.remove(at: indexPath.row)
                self.reloadData()
                Notification.displayNotification(view: self.view, text: message)
            }
            add.backgroundColor = UIColor(red: 72/255.0, green: 226/255.0, blue: 72/255.0, alpha: 1.0)
            actions.append(add)
        }
        
        return actions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.restorationIdentifier == "itemInfo"){
            let dest = segue.destination as! ItemInfoTableViewController
            if let selectedRow = self.tableView.indexPathForSelectedRow {
                let item = items[selectedRow.row]
                dest.setItem(item)
            }
        }
    }
    
    @IBAction func startEndShoppingAction(_ sender: Any) {
        if (!DataHolder.shoppingMode) {
            if (DataHolder.stores.count > 0){
                let storeSelector = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storeSelector") as! StoreSelectorViewController
                storeSelector.respondTo = self
                self.addChildViewController(storeSelector)
                storeSelector.view.frame = self.view.frame
                self.view.addSubview(storeSelector.view)
                storeSelector.didMove(toParentViewController: self)
            } else {
                Notification.displayError(view: self.view, text: "Add a store first", bottom: false)
            }
        } else {
            toggleShoppingMode()
        }
    }
    
    private func filterList(_ searchText:String){
        self.items.removeAll()
        for item in DataHolder.items {
            if (item.name.contains(searchText) || searchText == ""){
                self.items.append(item)
            }
        }
    }
}
