//
//  ViewController.swift
//  Lunch
//
//  Created by James Anderson on 22/06/2019.
//  Copyright © 2019 The Productive Developer. All rights reserved.
//

import UIKit
import CoreData

class WhoNeedsToGetViewController: UITableViewController {
    
    var people = [Person]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadData()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhoNeedsCell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func loadData() {
        do {
            let request : NSFetchRequest<Person> = Person.fetchRequest()
            try people = context.fetch(request)
        } catch {
            print("Error loading people data: \(error)")
        }
    }
}

