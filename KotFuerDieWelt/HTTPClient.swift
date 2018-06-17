//
//  HTTPClient.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import Foundation
import Alamofire

class HTTPClient{
    
    let address = "http://192.168.43.66:8080"
    
    
    static var shared: HTTPClient{
        return instance
    }
    
    private static let instance = HTTPClient()
    
    
    func get(message: String) -> String?{
        Alamofire.request(address + "?position\(message)").responseJSON { (response) in
            return response
        }
        return nil
    }
}
