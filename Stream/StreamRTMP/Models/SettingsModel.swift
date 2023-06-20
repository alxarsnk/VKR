//
//  SettingsModel.swift
//  StreamRTMP
//
//  Created by Alexandr Arsenyuk on 24.04.2023.
//

import Foundation

struct Resolution: Codable {
    let width: Int
    let height: Int
    
    func description() -> String {
        "\(width) x \(height)"
    }
    
    func reversed() -> Resolution {
        return Resolution(width: height, height: width)
    }
    
    enum Resolutions {
        static var hd: Resolution {
            return Resolution(width: 1280, height: 720)
        }
        static var fullHD: Resolution {
            return Resolution(width: 1920, height: 1080)
        }
        static var K2: Resolution {
            return Resolution(width: 2560, height: 1440)
        }
        static var K4: Resolution {
            return Resolution(width: 3840, height: 2160)
        }
        
    }
}

class SettingsModel: Codable {
    
    let resolution: Resolution
    let serverAddress: String
    let servername: String
    
    
    init(resolution: Resolution, serverAddress: String, servername: String) {
        self.resolution = resolution
        self.serverAddress = serverAddress
        self.servername = servername
    }
    
    static let `default` = SettingsModel(
        resolution: Resolution.Resolutions.hd,
        serverAddress: "",
        servername: ""
    )
    
    var description: String {
        return "Address: \(serverAddress), Name: \(servername), Resolution: \(resolution.description())"
    }
}
