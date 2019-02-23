//
//  Helper.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 23/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == Tournament
{
    func matching(_ text: String?) -> [Tournament]
    {
        if let text = text , text.count > 0
        {
            return self.filter { $0.name.localizedCaseInsensitiveContains(text) }
            
        } else
        {
            return self
        }
    }
}

extension Array where Element == Ground
{
    func matchingGround(_ text: String?) -> [Ground]
    {
        if let text = text , text.count > 0
        {
            return self.filter { $0.name.localizedCaseInsensitiveContains(text) }
            
        } else
        {
            return self
        }
    }
}

extension Array where Element == Team
{
    func matchingTeam(_ text: String?) -> [Team]
    {
        if let text = text , text.count > 0
        {
            return self.filter { $0.name.localizedCaseInsensitiveContains(text) }
            
        } else
        {
            return self
        }
    }
}

extension Array where Element == Player
{
    func matchingPlayer(_ text: String?) -> [Player]
    {
        if let text = text , text.count > 0
        {
            return self.filter { $0.name.localizedCaseInsensitiveContains(text) }
            
        } else
        {
            return self
        }
    }
}


extension UIImageView {
    
    func setCustomImage(_ imgURLString: String?) {
        guard let imageURLString = imgURLString else {
            self.backgroundColor = UIColor.lightText
            return
        }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                
                if data != nil
                {
                    self.image = UIImage(data: data!)
                }
                else
                {
                    self.backgroundColor = UIColor.lightText
                }
            }
        }
    }
}
