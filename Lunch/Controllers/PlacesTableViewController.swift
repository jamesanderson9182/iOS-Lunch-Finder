//
//  PlacesTableViewController.swift
//  Lunch
//
//  Created by James Anderson on 22/06/2019.
//  Copyright © 2019 The Productive Developer. All rights reserved.
//

import UIKit
import CoreData

class PlacesTableViewController: UITableViewController {

    var places = [Place]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemClicked))
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }


    func loadData() {
        do {
            let request : NSFetchRequest<Place> = Place.fetchRequest()
            places = try context.fetch(request)
        } catch {
            print("Error loading places: \(error)")
        }
        
        tableView.reloadData()
    }
    
    @objc func barButtonItemClicked() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Place To Eat", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Place", style: .default) { (action) in
            let place = Place(context: self.context)
            place.name = textField.text!
            // TODO: What do we do about being a treat??
            place.isTreat = false
            self.places.append(place)
            
            do {
                try self.context.save()
                self.tableView.reloadData()
            } catch {
                print("Error saving Place \(error)")
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "E.g. Subway, PizzaHut or McDonalds"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
