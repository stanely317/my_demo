//
//  Decoder.swift
//  my_demo
//
//  Created by Class on 2022/4/10.
//

import Foundation

struct jsonObject: Codable {

    let error_code: String
    let error_text: String?
    var result: results
    
}

struct results: Codable {
    
    let lightyear_list: [StoreItem]
    // 熱門
    let stream_list: [StoreItem]
    // 首頁
    
}

struct StoreItem: Codable {
    
    let head_photo: URL?
    let nickname: String?
    let online_num: Int?
    let stream_title: String?
    let tags: String?
    
}

