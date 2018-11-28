//
//  DeviceManager.swift
//  Flickr
//
//  Created by murugan on 27/11/18.
//  Copyright © 2018 com.murugan.app. All rights reserved.
//

import Foundation
import UIKit

public struct DeviceManager
{
    public static var deviceHeight : CGFloat{
        return UIScreen.main.bounds.size.height
        
    }
    public static var deviceWidth : CGFloat{
        return UIScreen.main.bounds.size.width
        
    }
}

