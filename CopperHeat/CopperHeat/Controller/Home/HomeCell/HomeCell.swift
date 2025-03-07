//
//  HomeCell.swift
//  CopperHeat
//
//  Created by vtadmin on 07/10/24.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleHost: UILabel!
    @IBOutlet weak var lblHost: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnConnect.cornerRadius(cornerRadius: 3)
        mainView.cornerRadius(cornerRadius: 5)
        mainView.makeCardView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
