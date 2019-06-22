//
//  Setup.swift
//  Lunch
//
//  Created by James Anderson on 22/06/2019.
//  Copyright © 2019 The Productive Developer. All rights reserved.
//

import UIKit

class SetupTableViewController: UITableViewController {
    
    let settings = ["People"]

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
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
