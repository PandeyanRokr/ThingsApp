//
//  Constants.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import Foundation
import UIKit

class Constants {
    struct Value {
        static let zeroInt: Int = 0
        static let zeroFloat: CGFloat = 0.0
        static let AllowedAlphaNumericCharacters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    }
    
    struct ColorCode {
        static let red: CGFloat = 102.0
        static let green: CGFloat = 102.0
        static let blue: CGFloat = 102.0
        static let fadedGray: CGFloat = 200.0
    }
    
    struct Storyboard {
        static let UsersList = "UsersList"
    }
    
    struct CellIdentifier {
        static let UserTableViewCell = "UserTableViewCell"
        static let SelectedUserTableViewCell = "SelectedUserTableViewCell"
    }
    
    struct NibName {
        static let UserTableViewCell = "UserTableViewCell"
        static let SelectedUserTableViewCell = "SelectedUserTableViewCell"
    }
    
    struct ViewControllerId {
        static let UsersListViewController = "UsersListViewController"
        static let SelectedUserViewController = "SelectedUserViewController"
        static let AddUserViewController = "AddUserViewController"
    }
    
    struct CornerRadius {
        static let value8: CGFloat = 8.0
        static let value5: CGFloat = 5.0
    }
}

typealias TupleRGB = (CGFloat, CGFloat, CGFloat)

enum REQUEST_TYPE:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

func debugLog(_ items: Any ...) {
     #if DEBUG
        print(items)
    #endif
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
