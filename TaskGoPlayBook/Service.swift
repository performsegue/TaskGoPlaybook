//
//  Service.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 22/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import Foundation

import Foundation

class Service {
    static let shared = Service()
    
    
    func fetchContacts<T:Decodable>(_ type:T.Type, urlString: String,completion: @escaping (T?, Error?) -> ())
    {
       // let urlString = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch Contacts:", err)
                fatalError("Application Crash")
            }
            
            // check response
            let httpResponse = (resp as? HTTPURLResponse)?.statusCode
            print(httpResponse)
            guard let data = data else { return }
            do {
                let downloadedData = try JSONDecoder().decode(type, from: data)
                DispatchQueue.main.async {
                    completion(downloadedData, nil)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
            }.resume()
        
    }
}
