//
//  HostViewController.swift
//  IP
//
//  Created by Yu Sugawara on 2/6/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import UIKit
import IP

class HostViewController: BaseViewController {
    
    var host: Host? {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func refresh() {
        do {
            host = try Host.current()
        } catch {
            host = nil
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
        return host == nil ? 0 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DescriptionCell
        cell.selectionStyle = .none
        
        guard let host = host else {
            cell.nameLabel.text = nil
            cell.descriptionLabel.text = nil
            return cell
        }
        
        let name: String
        var desc = ""
        var ips: [IP]? = nil
        switch indexPath.row {
        case 0:
            name = "Name"
            desc = host.name.isEmpty ? " " : host.name
        case 1:
            name = "IPv4"
            desc = "Unknown"
            ips = host.ipv4s
        case 2:
            name = "IPv6"
            desc = "Unknown"
            ips = host.ipv6s
        default:
            fatalError()
        }
        
        if let ips = ips {
            if ips.isEmpty {
                desc = "None"
            } else {
                desc = ips.map { (ip) -> String in
                    return "\(ip)" +
                        "\n\n" + {
                            do {
                                if let message = try System.retrieveDefaultGatewayMessage(from: ip) {
                                    return "\(message)"
                                }
                            } catch { }
                            return "gateway: Not found"
                        }()
                    }.joined(separator: "\n-----\n")
            }
        }
        
        cell.nameLabel.text = name
        cell.descriptionLabel.text = desc
        
        return cell
    }
        
}
