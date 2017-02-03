//
//  RoutingTableViewController.swift
//  IP
//
//  Created by Yu Sugawara on 2/4/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import UIKit
import IP

class RoutingTableViewController: BaseViewController {
    
    @IBOutlet weak var flagsControl: UISegmentedControl!
    var flags: RoutingMessage.Flags {
        switch flagsControl.selectedSegmentIndex {
        case 0: return [.availableNetwork]
        case 1: return []
        default: fatalError()
        }
    }
    
    var messages: [RoutingMessage]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func refresh() {
        do {
            messages = try System.routingTable(flags)
        } catch {
            messages = nil
            print(error)
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DescriptionCell
        cell.selectionStyle = .none
        
        let message = messages![indexPath.row]
        
        print("[\(indexPath.row)] \(message)")
        cell.nameLabel.text = "\(message.name)"
        
        cell.descriptionLabel.text = message.description + "\n\n" + {
            do {
                if let interface = try Interface.all().first(where: {
                    message.name == $0.name && message.destination.version == $0.ip.version
                }) {
                    return "\(interface)"
                }
            } catch { }
            return "interface: Not found"
            }()
    
        return cell
    }
    
}
