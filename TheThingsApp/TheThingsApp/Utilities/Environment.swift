//
//  Environment.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-28.
//

import UIKit
import Foundation

public enum Environment {
    //MARK: - Keys
    enum Keys {
        enum Plist {
            static let appEnvKey = "APP_ENV"
            static let usersListURLKey = "USERLIST_URL"
        }
    }
    
    //MARK: - Private Methods
    private static let plistInfo = Bundle.main.infoDictionary
    
    
    private static func urlWithKey(_ key :String) -> URL? {
        guard let rootURLstring = Environment.plistInfo?[key] as? String else {
            debugLog("\(key) not set in plist for this environment")
            return nil
        }
        return URL(string: rootURLstring)
    }
    
    
    private static func value(forKey key :String) -> String? {
        return Environment.plistInfo?[key] as? String
    }
    
    
    //MARK: - Server URLs
    static let usersListURL: URL? = urlWithKey(Keys.Plist.usersListURLKey)
    
    //MARK: - App Env
    static let environmentIdentifier:String = value(forKey: Keys.Plist.appEnvKey)!
}


enum Server {
    case UsersList
    
    func url() -> URL {
        var url:URL?
        switch self {
        case .UsersList:
            url = Environment.usersListURL
        }
        return url!
    }
}

