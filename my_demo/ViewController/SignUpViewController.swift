//
//  SignUpViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/6.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var AccountTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if NameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            AccountTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "請檢查輸入是否正確。"
        }
       return nil
    }
    
    @IBAction func ClickSendButton(_ sender: Any) {
        // 檢查是否有輸入錯誤
        let error = validateFields()
        if error != nil {
            self.showToast(message: error!, font: .systemFont(ofSize: 13.0))
        }
        else {
            let Nickname = NameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let account = AccountTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 建立使用者
            Auth.auth().createUser(withEmail: account, password: password) { (result, err) in                
                if err != nil {
                    // There was an error creating the user
                    self.showToast(message: "建立使用者錯誤，請檢查格式", font: .systemFont(ofSize: 13.0))
                }
                else {
                    //存入使用者暱稱
                    let db = Firestore.firestore()
                    db.collection("user").addDocument(data: ["name":Nickname, "uid": result!.user.uid ]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showToast(message: "資料存取錯誤", font: .systemFont(ofSize: 13.0))
                        }
                    }
                    // 登入後轉移至主畫面
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }

}


