//
//  PlaceTableCell.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 10/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//

import UIKit

class PlaceTableCell: UITableViewCell {

    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
