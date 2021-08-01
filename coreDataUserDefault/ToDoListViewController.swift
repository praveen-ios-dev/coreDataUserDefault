//
//  ViewController.swift
//  coreDataUserDefault
//
//  Created by kumar praveen on 29/07/21.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    let defaults = UserDefaults()
    var itemArray : [Items] = []
    var catagory : CatagoryItem?{
        didSet{
            loadData()
        }
    }
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // MARK:- Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.black
        loadData()
    }
    
    fileprivate func loadData(_ request: NSFetchRequest<Items> = Items.fetchRequest(), predicate :NSPredicate? = nil) {
        let contexPredicate = NSPredicate(format: "child.name MATCHES %@", catagory!.name!)
        if let predicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [contexPredicate,predicate])
        }else{
            request.predicate = contexPredicate
        }
        
        do{
            itemArray = try contex.fetch(request)
        }catch{
            print("Got an error in saving data to persistant manager \(error)")
        }
    }

    fileprivate func saveItem() {
        do{
            try contex.save()
            loadData()
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
                let value = Items(context: self.contex)
                value.title = text
                self.itemArray.append(value)
                value.child = self.catagory
                print(self.itemArray.count)
                
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
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    
    //Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //contex.delete(itemArray[indexPath.row])
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0{
            let Request : NSFetchRequest<Items> = Items.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            Request.predicate = predicate
            Request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(Request,predicate: predicate)
            tableView.reloadData()
        }else{
            let Request : NSFetchRequest<Items> = Items.fetchRequest()
            loadData(Request)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }

    }
}

