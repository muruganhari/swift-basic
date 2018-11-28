//
//  APIRequestManager.swift
//  Flickr
//
//  Created by murugan on 27/11/18.
//  Copyright © 2018 com.murugan.app. All rights reserved.
//

import Foundation

let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f08d00b0d8d1cd26027447108e09dd8e& format=json&nojsoncallback=1&safe_search=1" // Domain url

class APIRequestManager {
    
    func getDashboardList(url: String, param :Dictionary<String , AnyObject>? = nil,  completion : @escaping(_ success : Bool , _ jsonObject : ImageModel?) -> ())
    {
        get(request: clientURLRequestGetMethod(path: url)) { (success, object) in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    completion(true, ImageModel.convertData(data: object as! Data))
                }else{
                    completion(false, ImageModel.convertData(data: object as! Data))
                }
            })
        }
    }
    private func clientURLRequestGetMethod(path: String) -> NSMutableURLRequest {
        let urlWithParams: NSString = baseURL+path as NSString
        let urlStr  = urlWithParams.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let request = NSMutableURLRequest(url: NSURL(string: urlStr)! as URL)
        return request
    }
    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if let  data = data {
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, data as AnyObject?)
                }else
                {
                    completion(true, data as AnyObject?)
                }
            }
            }.resume()
    }
    
}
