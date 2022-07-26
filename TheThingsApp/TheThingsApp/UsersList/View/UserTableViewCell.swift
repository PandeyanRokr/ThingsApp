//
//  UserTableViewCell.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgViewSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseView.layer.cornerRadius = Constants.CornerRadius.value8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func configureView(user: User) {
        self.title.text = user.name
        let tintColor: UIColor = user.isSelected ? .green : .red
        let imageCheckmark = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        imgViewSelection.image = imageCheckmark
    }
    
    //MARK:- Set Cell Color
    func setCellColor(_ tupleRGB: TupleRGB) {
        let color = UIColor(red: tupleRGB.0/255.0, green: tupleRGB.1/255.0, blue: tupleRGB.2/255.0, alpha: 1.0)
        self.baseView.backgroundColor = color
    }
    
}
