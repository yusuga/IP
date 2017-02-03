//
//  InterfaceViewController.swift
//  IP
//
//  Created by Yu Sugawara on 2/3/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import UIKit
import IP

class InterfaceViewController: BaseViewController {
    
    var interfaces: [Interface]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func refresh() {
        do {
            interfaces = try Interface.all()
            print("Interfaces.count: \(interfaces!.count)")
        } catch {
            interfaces = nil
            let alert = UIAlertController(title: "Interface Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interfaces?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DescriptionCell
        cell.selectionStyle = .none
        
        let interface = interfaces![indexPath.row]
        
        print("[\(indexPath.row)] \(interface)")
        cell.nameLabel.text = "\(interface.name)"
        cell.descriptionLabel.text = "\(interface)" + "\n\n" + {
            do {
                if let message = try System.retrieveDefaultGatewayMessage(from: interface) {
                    return message.description
                }
            } catch { }
            return "gateway: Unknown"
            }()
        
        return cell
    }
    
}
