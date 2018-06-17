//
//  HTTPClient.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import Alamofire

class HTTPClient{
    
    let address = "http://151.216.10.34:8080/trashcans"
    
    
    static var shared: HTTPClient{
        return instance
    }
    
    private static let instance = HTTPClient()
    
    
    func get(message: String) -> String?{
        let request = address + "?position=\(message)"
        print(request)
        Alamofire.request(request).responseJSON { response in
            print(response.data)
        }
        return nil
    }
}
