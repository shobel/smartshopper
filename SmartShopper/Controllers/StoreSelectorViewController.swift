
//
//  StoreSelectorViewController.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 9/9/18.
//  Copyright © 2018 Samuel Hobel. All rights reserved.
//

import UIKit

class StoreSelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedStore: String?
    public var respondTo: ShoppingListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10; 
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHolder.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath)
        cell.textLabel?.text = DataHolder.stores[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStore = DataHolder.stores[indexPath.row]
        self.view.removeFromSuperview()
        if (selectedStore != nil){
            respondTo.setItems(selectedStore!)
        }
    }
}
