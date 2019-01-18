//
//  Codables.swift
//  virtualTourist
//
//  Created by Tawfeeq on 29/12/2018.
//  Copyright © 2018 tam. All rights reserved.
//

import Foundation


struct AlbumResponse : Codable {
    var photos : Photos
}

struct Photos : Codable {
    var photo : [PhotoList]
}

struct PhotoList : Codable {
    var id : String
    var server : String
    var secret : String
    var farm : Int
    var url : String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }

}
