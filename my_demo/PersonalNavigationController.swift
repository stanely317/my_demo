//
//  PersonalNavigationController.swift
//  my_demo
//
//  Created by Class on 2022/4/18.
//

import UIKit
import Firebase

class PersonalNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            
            let PersonalVC = (self.storyboard?.instantiateViewController(withIdentifier: "PersonalinfoVC"))!
            setViewControllers([PersonalVC], animated: false)
//            print("user login!!!!!")
            
        }else{
            
            let LoginVC = (self.storyboard?.instantiateViewController(withIdentifier: "LoginVC"))!
            setViewControllers([LoginVC], animated: false)
//            print("No user~~~~~")

        }
        
    }
    


}
