//
//  ImageModel.swift
//  Flickr
//
//  Created by murugan on 27/11/18.
//  Copyright © 2018 com.murugan.app. All rights reserved.
//

import Foundation

struct ImageModel : Decodable
{
    let photos : PhotoDetailsModel?
    static func convertData(data: Data) -> ImageModel? {
        let model = try! JSONDecoder().decode(ImageModel.self, from: data)
        return model
    }
}

struct PhotoDetailsModel : Codable
{
    let page : Int?
    let pages : Int?
    let perpage : Int?
    let total : String?
    let photo : [PhotoListModel]?
}

struct PhotoListModel : Codable
{
    let id : String?
    let owner : String?
    let secret : String?
    let server : String?
    let farm : Int?
    let title : String?
    let isfriend : Int?
    let isfamily : Int?
}
