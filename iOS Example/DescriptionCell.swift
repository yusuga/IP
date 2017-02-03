//
//  DescriptionCell.swift
//  IP
//
//  Created by Yu Sugawara on 2/3/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import UIKit

public class DescriptionCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public class func create<T: DescriptionCell> () -> T {
        return nib().instantiate(withOwner: self,
                                 options: nil)[0] as! T
    }

}
