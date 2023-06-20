//
//  Defaults.swift
//  StreamRTMP
//
//  Created by Alexandr Arsenyuk on 24.04.2023.
//

import Foundation

class Defaults {
    
    private init() {}
    
    static let shared: Defaults = Defaults()
    
    var settings: SettingsModel {
        get {
            if let settignsData = UserDefaults().data(forKey: "Settings") {
                let decoder = JSONDecoder()
                
                let settings = try? decoder.decode(SettingsModel.self, from: settignsData)
                return settings ?? .default
            } else {
                return .default
            }
        }
        set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "Settings")
        }
    }
    
}
