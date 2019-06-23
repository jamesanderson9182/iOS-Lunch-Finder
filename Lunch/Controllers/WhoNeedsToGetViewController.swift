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
    var peopleWhoNeedToGet = [Person]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // TODO: How do I reload the people when I reverse a segue??
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(findPlaceTapped))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhoNeedsCell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        cell.accessoryType = peopleWhoNeedToGet.contains(people[indexPath.row]) ? .checkmark : .none
        cell.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if peopleWhoNeedToGet.contains(people[indexPath.row]) {
            peopleWhoNeedToGet.remove(at: peopleWhoNeedToGet.firstIndex(of: people[indexPath.row])!)
        } else {
            peopleWhoNeedToGet.append(people[indexPath.row])
        }
        tableView.reloadData()
    }
    
    @objc func findPlaceTapped() {
        let placesLikedByEveryone = getPlacesLikedByEveryone()
        
        var message = ""
        placesLikedByEveryone.forEach { (place) in
            message.append(contentsOf: place.name! + "\n")
        }
        
        if message == "" {
            message = "I can't find somewhere everyone likes. Split up?"
        }
        
        let alertController = UIAlertController(title: "Places Everyone Likes:", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    fileprivate func loadData() {
        do {
            let request : NSFetchRequest<Person> = Person.fetchRequest()
            try people = context.fetch(request)
        } catch {
            print("Error loading people data: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Who Needs To Get Logic:
    fileprivate func getPlacesLikedByEveryone() -> [Place] {
        var placesLikedByEveryone = [Place]()
        let allPlaces = getAllPlaces()
        allPlaces.forEach { (place) in
            if everyPersonWhoNeedsToGetLikes(place: place) {
                placesLikedByEveryone.append(place)
            }
        }
        
        return placesLikedByEveryone
    }
    
    fileprivate func getAllPlaces() -> [Place] {
        do {
            return try context.fetch(Place.fetchRequest())
        } catch {
            print("Error finding data \(error)")
            return [Place]()
        }
    }
    
    func everyPersonWhoNeedsToGetLikes(place: Place) -> Bool {
        var result = true
        
        peopleWhoNeedToGet.forEach { (person) in
            let personPlaces = getPersonPlaces(person)
            let placesPersonLikes = getPlacesPersonLikes(personPlaces: personPlaces)
            
            if placesPersonLikes.contains(place) == false {
                // This may get slow over time as more people and places get added.
                result = false
            }
        }
        
        return result
    }
    
    fileprivate func getPersonPlaces(_ person: (Person)) -> [PersonPlace] {
        do {
            let personPlacesRequest : NSFetchRequest<PersonPlace> = PersonPlace.fetchRequest()
            personPlacesRequest.predicate = NSPredicate(format: "person.name MATCHES %@", person.name!)
            return try context.fetch(personPlacesRequest)
        } catch {
            print("Error retrieving placesLikedByPerson \(error)")
            return [PersonPlace]()
        }
    }
    
    fileprivate func getPlacesPersonLikes(personPlaces : [PersonPlace]) -> [Place] {
        var placesPersonLikes = [Place]()
        personPlaces.forEach({ (personPlace) in
            placesPersonLikes.append(personPlace.place!)
        })
        return placesPersonLikes
    }
}
