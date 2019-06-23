//
//  PersonLikesTableViewController.swift
//  Lunch
//
//  Created by James Anderson on 22/06/2019.
//  Copyright © 2019 The Productive Developer. All rights reserved.
//

import UIKit
import CoreData

class PersonLikesTableViewController: UITableViewController {

    var personPlaces = [PersonPlace]()
    var allPlaces = [Place]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var person : Person? {
        didSet {
            navigationItem.title = "Tap Where \(person!.name!) Likes"
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonLikesCell", for: indexPath)
        
        cell.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        cell.textLabel?.text = allPlaces[indexPath.row].name
        var personLikesThePlaceAtTheCurrentCell = false
        personPlaces.forEach { (personPlace) in
            if personPlace.place?.name == self.allPlaces[indexPath.row].name {
                personLikesThePlaceAtTheCurrentCell = true
            }
        }
        cell.accessoryType = personLikesThePlaceAtTheCurrentCell ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = allPlaces[indexPath.row]
        let selectedCell = tableView.cellForRow(at: indexPath)!
        
        if selectedCell.accessoryType == .checkmark {
            selectedCell.accessoryType = .none
            personPlaces.forEach { (personPlace) in
                if personPlace.place == selectedPlace {
                    context.delete(personPlace)
                }
            }
        } else {
            selectedCell.accessoryType = .checkmark
            let newPlaceLikedByPerson = PersonPlace(context: context)
            newPlaceLikedByPerson.person = person
            newPlaceLikedByPerson.place = selectedPlace
            personPlaces.append(newPlaceLikedByPerson)
        }
        do {
            try context.save()
        } catch {
            print("Error updating places liked by person")
        }
        
        loadData()
    }
    func loadData() {
        let allPlacesRequest : NSFetchRequest<Place> = Place.fetchRequest()
        do {
            try allPlaces = context.fetch(allPlacesRequest)
        } catch {
            print("Error retrieving allPlaces \(error)")
        }
        
        
        let personPlacesRequest : NSFetchRequest<PersonPlace> = PersonPlace.fetchRequest()
        personPlacesRequest.predicate = NSPredicate(format: "person.name MATCHES %@", person!.name!)
        personPlaces = [PersonPlace]()
        do {
            try personPlaces = context.fetch(personPlacesRequest)
        } catch {
            print("Error retrieving placesLikedByPerson \(error)")
        }
        tableView.reloadData()
    }
}
