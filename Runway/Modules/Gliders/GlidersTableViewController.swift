//
//  GlidersTableViewController.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import RealmSwift

class GlidersTableViewController: UITableViewController {
    
    private var gliders: Results<Glider>?
    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            return nil
        }
    }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gliders = realm?.objects(Glider)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Gliders"
    }
    
    // MARK: - Actions
    
    @IBAction func reload(sender: AnyObject) {
        SBWebService().fetchGliders { response in
            if let _: [NSDictionary] = (response.data as! NSDictionary)["gliders"] as? [NSDictionary] {
//                self.gliders = list
                dispatch_main {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gliders?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GliderCell") as! GliderTableViewCell
        let glider: Glider = gliders![indexPath.row]
        cell.configure(glider: glider)
        return cell
    }
}
