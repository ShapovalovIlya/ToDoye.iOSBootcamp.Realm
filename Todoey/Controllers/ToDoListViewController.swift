//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    //MARK: - Public properties
    var selectedCategory: Category? {
        didSet {
          //  loadItems()
        }
    }
    
    //MARK: - Private properties
    private var itemArray = [Item]()
    private let K = Constant()
   
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
 //       searchBar.delegate = self
        
    }
    //MARK: - Table View data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table View delegate methods
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Write trailing swipe action for the delete
        let deleteItem = UIContextualAction(style: .destructive, title:  "Delete", handler: { [weak self] (_, _, _) in
            guard let self = self else { return }
        //    self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            self.saveItems()
        })
        return UISwipeActionsConfiguration(actions: [deleteItem])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Write leading swipe action for the mark
        let markAction = UIContextualAction(style: .normal, title: "Done") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.itemArray[indexPath.row].done.toggle()
            self.saveItems()
            tableView.reloadRows(at: [indexPath], with: .right)
        }
        markAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [markAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done.toggle()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add item", style: .default) { [weak self] action in
            guard let self = self else { return }
//            //what will happen once the user clicks the "Add item" button on UIAlert
//            let newItem = ItemList(context: self.context)
//            newItem.title = textField.text
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveItems()
        }
        
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    //MARK: - Private methods
    private func saveItems() {
        do {
   //         try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
//    private func loadItems(with request: NSFetchRequest<ItemList> = ItemList.fetchRequest(), predicate: NSPredicate? = nil) {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let aditionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }
//        tableView.reloadData()
//    }
    
}
//MARK: - UISearchBarDelegate
//extension ToDoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Create generic request
//        let searchRequest: NSFetchRequest<ItemList> = ItemList.fetchRequest()
//        // Create predicate for request
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        // Create sort descriptor fo requesting data.
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        searchRequest.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: searchRequest, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        } else {
//            // Note. Using search request at this method provide more comfortable seatch for user.
//            // No need to interact with "search" button on keyboard to start search.
//            let searchRequest: NSFetchRequest<ItemList> = ItemList.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: searchRequest, predicate: predicate)
//        }
//    }
//
//}



