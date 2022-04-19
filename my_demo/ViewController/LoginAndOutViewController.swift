//
//  LoginViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/6.
//

import UIKit
import Firebase

class LoginAndOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    self.navigationController?.viewDidLoad()
//                    self.Errorlabel.text = "Lougout Successful!!"
                } catch {
//                    self.Errorlabel.text = error.localizedDescription
                }
        }
        else{
//            Errorlabel.text = "你沒有登入 ><"
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
