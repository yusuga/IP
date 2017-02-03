//
//  BaseViewController.swift
//  IP
//
//  Created by Yu Sugawara on 2/7/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(DescriptionCell.nib(), forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @IBAction func refresh() {}

}
