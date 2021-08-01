//
//  CatagoryViewController.swift
//  coreDataUserDefault
//
//  Created by kumar praveen on 01/08/21.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {
    
    var catagoryArray : [CatagoryItem] = []
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        do {
            let request : NSFetchRequest<CatagoryItem> = CatagoryItem.fetchRequest()
            catagoryArray = try contex.fetch(request)
        }catch{
            print("Network \(error)")
        }
        
    }
    
    func saveData(){
        do {
            try contex.save()
        }catch{
            print("unable to save data \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {

        var textField = UITextField()
        let alert = UIAlertController(title: "Add Catagory", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter Catagories"
            textField = textfield
        }
        let action = UIAlertAction(title: "Click to add", style: .default) { (action) in
            if let text = textField.text , !text.isEmpty{
                let textValue = CatagoryItem(context: self.contex)
                textValue.name = text
                self.catagoryArray.append(textValue)
                print(self.catagoryArray.count)
                self.saveData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        cell.textLabel?.text = catagoryArray[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationSegue = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationSegue.catagory = catagoryArray[indexPath.row]
        }
        
    }
    
}
