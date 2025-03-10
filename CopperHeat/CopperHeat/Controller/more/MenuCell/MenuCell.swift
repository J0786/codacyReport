//
//  MenuCell.swift
//  CopperHeat
//
//  Created by vtadmin on 08/10/24.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainview.cornerRadius(cornerRadius: 8)
        mainview.makeCardView()
        // Initialization code
    }
}
