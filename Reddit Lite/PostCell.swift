//
//  PostCell.swift
//  Reddit Lite
//
//  Created by Joseph Pereniguez on 24/11/2018.
//  Copyright © 2018 Joseph Pereniguez. All rights reserved.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
