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
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    // MARK:- Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    fileprivate func loadData(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from : data)
            }catch{
                print("error = \(error)")
            }
            
        }
    }
    
    fileprivate func saveItem() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.filePath!)
        }catch{
            print("data encoded filePath error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //IBActios
    
    
    @IBAction func additemButtonTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New todoe item", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add new items"
            textField = textfield
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text , !text.isEmpty{
                let item = Item()
                item.name = text
                self.itemArray.append(item)
                self.saveItem()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

