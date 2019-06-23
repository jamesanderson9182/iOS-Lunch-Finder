//
//  PeopleTableViewController.swift
//  Lunch
//
//  Created by James Anderson on 22/06/2019.
//  Copyright © 2019 The Productive Developer. All rights reserved.
//

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController {
    var people = [Person]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemClicked))
        
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        cell.textLabel?.text = people[indexPath.row].name
        
        return cell
    }
    
    @objc func barButtonItemClicked() {
        var textView = UITextField()
        
        let alert = UIAlertController(title: "Add new Lunch Person", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Person", style: .default) { (action) in
            let person = Person(context: self.context)
            person.name = textView.text
            self.people.append(person)
            do {
                try self.context.save()
            } catch {
                print("Error saving person")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Their name. E.g. Jonny Appleseed"
            alertTextField.autocapitalizationType = .words
            
            textView = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPersonLikesPlaces", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! PersonLikesTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.person = people[indexPath.row]
        }
    }
    
    fileprivate func loadData() {
        do {
            let request : NSFetchRequest<Person> = Person.fetchRequest()
            try people = context.fetch(request)
        } catch {
            print("Error loading people data: \(error)")
        }
        tableView.reloadData()
    }
}
