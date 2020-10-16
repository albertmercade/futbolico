//
//  RequestAPI.swift
//  Futbolico
//
//  Created by Albert Mercadé on 26/06/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import Foundation

class RequestSession {
    let session: URLSession!
    
    init() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = false
        session = URLSession.init(configuration: config)
    }
    
    func requestAPI(url: String, headers: [String:String], completionHandler: ((Data) -> Void)!) {
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest.init(url: NSURL(string: encodedURL)! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            return completionHandler(data!)
        }
        
        dataTask.resume()
    }
}
