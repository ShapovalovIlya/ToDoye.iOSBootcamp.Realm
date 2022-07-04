//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Илья Шаповалов on 25.06.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //MARK: - Private properties
    private let realm = try! Realm()
    private var categoryArray = [Category]()
    private let K = Constant()
    private let pullRefresh = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        pullRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(pullRefresh)
    }
    
    @objc private func refresh() {
        tableView.reloadData()
        pullRefresh.endRefreshing()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - Table view Delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
    }
    // Create trailing swipe action
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCategory = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            // here will be realm delete method
            self.categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            // here will be realm save method
                
        }
        return UISwipeActionsConfiguration(actions: [deleteCategory])
    }
    
    //MARK: - Data manipulation methods
    private func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadCategories() {
//        let request: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }
//        tableView.reloadData()
    }
    
    //MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add list", style: .default) { [weak self] action in
            guard let self = self else { return }
            let newCategory = Category()
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.save(category: newCategory)
        }
        
        alertController.addTextField { alertTextfield in
            alertTextfield.placeholder = "Create new category list"
            textField = alertTextfield
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}
