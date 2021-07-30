//
//  ViewController.swift
//  coreDataUserDefault
//
//  Created by kumar praveen on 29/07/21.
//

import UIKit

class ToDoListViewController: UITableViewController{
    let defaults = UserDefaults()
    var itemArray : [Item] = []
    
    
    
    
    @IBAction func additemButtonTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New todoe item", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add new items"
            textField = textfield
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text{
                let item = Item()
                item.name = text
                self.itemArray.append(item)
            }
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "savedItemArray")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = Item()
        item.name = "Kumar"
        itemArray.append(item)
        let item1 = Item()
        item1.name = "praveen"
        itemArray.append(item1)
        if let value = defaults.object(forKey: "savedItemArray") as? [Item]{
            itemArray = value
        }
    }
            
    // Datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

}

