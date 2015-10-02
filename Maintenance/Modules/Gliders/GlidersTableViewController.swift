//
//  GlidersTableViewController.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class GlidersTableViewController: UITableViewController {
    
    private var gliders = [NSDictionary]()
    
    // MARK: - View flow
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Gliders"
    }
    
    // MARK: - Actions
    
    @IBAction func reload(sender: AnyObject) {
        SBWebService().fetchGliders { response in
            if let list: [NSDictionary] = (response.data as! NSDictionary)["gliders"] as? [NSDictionary] {
                self.gliders = list
                dispatch_main {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15 //gliders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GliderCell")
        return cell!
    }
}
