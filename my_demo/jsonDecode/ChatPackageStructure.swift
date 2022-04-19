//
//  Chatroompackage.swift
//  my_demo
//
//  Created by Class on 2022/4/14.
//

import Foundation

struct packages: Codable {
    
    let event: String?          // 事件類型
    let room_id: String?        // 房間ID
    let sender_role: Int?       // 發話者來源
    let body: bodystructure?    // 內容，依據事件類型結構都不相同
    let time: String?           // 時間戳：服務廣播訊息的時間(unixNano)
    let action: String?         // 訊息類型，只有N是訪客能使用的，其餘都發不出去
    let content: String?        // 訊息文字內容
    
}

struct bodystructure: Codable {
    
    let chat_id: String?                // 發話者uuid，每次進連線自動產生
    let account: String?
    let nickname: String?               // 發話者暱稱
    let content: language?
    let entry_notice: noticestructure?
    let type: String?                   // 訊息類型
    let text: String?                   // 訊息內容

//    "recipient":"",
//    "accept_time":"1645500950878612400", // 服務接收到用戶發話的時間(unixNano)
//    "info": {sth inside}
//    "room_count":456, // 灌水在線人數
//    "real_count":6,   // 真實在線人數
//    "user_infos": {sth in}
//    "guardian_count":0,
//    "guardian_sum":0,
//    "contribute_sum":0
    
}

struct noticestructure: Codable {
    
    let username: String?   // 暱稱
    let action: String?     // 動作類別：enter(進入)、leave(離開)

//    "head_photo":"",
//    "entry_banner": {sth in}
    
}

struct language: Codable {
    
    let cn: String?
    let en: String?
    let tw: String?
    
}
