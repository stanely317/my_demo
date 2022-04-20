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
        self.addKeyboardObserver()
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
        
    @IBAction func TouchDownBackground(_ sender: Any) {
        NameTF.resignFirstResponder()
        AccountTF.resignFirstResponder()
        PasswordTF.resignFirstResponder()
    
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

extension SignUpViewController {
    
    func addKeyboardObserver() {
        // 因為selector寫法只要指定方法名稱即可，參數則是已經定義好的NSNotification物件，所以不指定參數的寫法「#selector(keyboardWillShow)」也可以
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        // notification.userInfo is dictionary type
        // keyboardframe 鍵盤外框尺寸
        // cgRectValue 寬
        // view : 擔任背景基底的view
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // 讓view回復原位
        view.frame.origin.y = 0
    }
    
    // 當畫面消失時取消監控鍵盤開闔狀態
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
