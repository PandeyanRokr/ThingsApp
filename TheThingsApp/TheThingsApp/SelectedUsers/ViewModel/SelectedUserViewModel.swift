//
//  SelectedUserViewModel.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import UIKit

class SelectedUserViewModel: NSObject {
    
    var selectedUsersList: [User]?
    
    //MARK: - Initializer
    init(usersList: [User]) {
        self.selectedUsersList = usersList
    }

}
