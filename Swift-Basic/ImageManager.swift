//
//  ImageManager.swift
//  Flickr
//
//  Created by murugan on 27/11/18.
//  Copyright © 2018 com.murugan.app. All rights reserved.
//

import Foundation
import UIKit

// Image downloaded and viewed asynchronously
extension UIImageView {
    public func gettingImageFromServer(urlString: String, defaultImage : String?) {
        if let placeHolderImage = defaultImage {
            self.image = UIImage(named: placeHolderImage)
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
