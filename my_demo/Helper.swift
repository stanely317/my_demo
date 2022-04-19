//  github: 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
//  File.swift
//  my_demo
//
//  Created by Class on 2022/4/9.
//

import Foundation
import UIKit

class Utilities {
        
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d]{6,12}")
        return passwordTest.evaluate(with: password)
    }
    
    static func Senderrole (input: packages) -> String {
        var output:String = ""
        switch input.sender_role {
        case -1:    // 發言
            output = "\(input.body!.nickname!):\(input.body!.text!)"
        case 0:     // 有人進出
            if input.body!.entry_notice!.action == "enter" {
                output = "\(input.body!.entry_notice!.username!) 已進入聊天室"
            }else{
                output = "\(input.body!.entry_notice!.username!)已離開聊天室"
            }
        case 5:     // 公告
            output = "\(input.body!.content!.cn!) \(input.body!.content!.tw!) \(input.body!.content!.en!)"
        default:
            print("the senderrole:",input.sender_role ?? 9)
        }
        return output
    }
    
}

extension UIViewController {
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height - 250, width: 250, height: 45))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
