//
//  Users.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let name, email, gender, status: String
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case gender
        case status
    }
}
