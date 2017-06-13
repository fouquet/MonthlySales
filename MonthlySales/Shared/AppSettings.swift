//
//  AppSettings.swift
//  MonthlySales
//
//  Created by René Fouquet on 12.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation

protocol DefaultsProtocol {
    func set(_ string: String, forKey: String)
    func string(forKey: String) -> String?
}

final class Defaults: DefaultsProtocol {
    private let internalDefaults = UserDefaults.standard
    
    func set(_ string: String, forKey: String) {
        internalDefaults.set(string, forKey: forKey)
        internalDefaults.synchronize()
    }
    
    func string(forKey: String) -> String? {
        return internalDefaults.string(forKey: forKey)
    }
}

enum Setting: String {
    case username
    case currencySymbol
}

protocol AppSettingsProtocol {
    func getStringFor(key: Setting) -> String?
    func setString(_ string: String, for key: Setting)
}

final class AppSettings: AppSettingsProtocol {
    var userDefaults: DefaultsProtocol = Defaults()
    
    func getStringFor(key: Setting) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    func setString(_ string: String, for key: Setting) {
        userDefaults.set(string, forKey: key.rawValue)
    }
}
