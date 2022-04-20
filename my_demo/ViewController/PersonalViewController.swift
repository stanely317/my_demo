//
//  PersonalViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/6.
//

import UIKit
import Firebase

class PersonalViewController: UIViewController {

    @IBOutlet weak var AccountTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func TouchDownBackGround(_ sender: Any) {
        AccountTF.resignFirstResponder()
        PasswordTF.resignFirstResponder()
    }
    
    @IBAction func LoginAction(_ sender: Any) {
           
        let account = AccountTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // 登入
        Auth.auth().signIn(withEmail: account, password: password) { (result, error) in
               if error != nil {
                   // Couldn't sign in
                   self.showToast(message: "請檢查帳號密碼是否輸入正確", font: .systemFont(ofSize: 13.0))
               }
               else {
                   self.tabBarController?.selectedIndex = 0
                   self.navigationController?.viewDidLoad()
              }
        }

        print(Auth.auth().currentUser?.email ?? "", Auth.auth().currentUser?.displayName ?? "")
    }

}

