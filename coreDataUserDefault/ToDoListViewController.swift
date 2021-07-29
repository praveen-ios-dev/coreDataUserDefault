//
//  ViewController.swift
//  coreDataUserDefault
//
//  Created by kumar praveen on 29/07/21.
//

import UIKit

class ToDoListViewController: UITableViewController{
    @IBAction func additemButtonTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New todoe item", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add new items"
            textField = textfield
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text{
                self.itemArray.append(text)
            }
            self.tableView.reloadData()
        }
        let action2 = UIAlertAction(title: "Cancle", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    var itemArray = ["Praveen", "lalu", "bulbul"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
            
    // Datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

