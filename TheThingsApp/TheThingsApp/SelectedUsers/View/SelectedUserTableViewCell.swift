//
//  SelectedUserTableViewCell.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import UIKit

class SelectedUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseView.layer.cornerRadius = Constants.CornerRadius.value8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Configure View
    func configureView(user: User) {
        self.title.text = user.name
    }
    
}
