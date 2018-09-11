//
//  StoreSetupViewController.swift
//  SmartShopper
//
//  Created by Samuel Hobel on 12/26/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class StoreSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_store.jpg")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (DataHolder.shouldCheckStores && DataHolder.stores.count > 0){
            DataHolder.shouldCheckStores = false
            performSegue(withIdentifier: "toTabBar", sender: nil)
        } else {
            DataHolder.shouldCheckStores = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numStores
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeName", for: indexPath) as! StoreChooserTableViewCell
        if (DataHolder.stores.count > indexPath.row){
            cell.storeNameField.text = DataHolder.stores[indexPath.row]
        }
        cell.storeNameField.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (!DataHolder.shouldCheckStores){
            DataHolder.stores.removeAll()
            for i in 0..<Constants.numStores{
                if let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? StoreChooserTableViewCell {
                    if (cell.storeNameField.text != ""){
                        DataHolder.stores.append(cell.storeNameField.text!)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
