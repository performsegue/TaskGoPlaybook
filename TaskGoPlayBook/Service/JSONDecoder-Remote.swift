//
//  JSONDecoder-Remote.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 21/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import Foundation
import UIKit

extension JSONDecoder
{
    func decode<T: Decodable>(_ type: T.Type, fromURL url: String, completion: @escaping (T) -> Void)
    {
        guard let url = URL(string: url) else
        {
            fatalError("Invalid URL")
        }
        DispatchQueue.global().async {
            do
            {
                
                let data = try Data(contentsOf: url)
                let downloadedData = try self.decode(type, from: data)
                DispatchQueue.main.async {
                    completion(downloadedData)
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        
    }
}
