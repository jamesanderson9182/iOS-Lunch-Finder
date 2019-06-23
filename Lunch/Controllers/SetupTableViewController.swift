//
//  Setup.swift
//  Lunch
//
//  Created by James Anderson on 22/06/2019.
//  Copyright © 2019 The Productive Developer. All rights reserved.
//

import UIKit

class SetupTableViewController: UITableViewController {
    
    let settings = ["People", "Places"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupCell", for: indexPath)
        
        cell.textLabel?.text = settings[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSetting = settings[indexPath.row]
        if selectedSetting == "People" {
            performSegue(withIdentifier: "goToPeople", sender: self)
        }
        if selectedSetting == "Places" {
            performSegue(withIdentifier: "goToPlaces", sender: self)
        }
    }
}
