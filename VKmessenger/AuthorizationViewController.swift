//
//  AuthorizationViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 29.10.2020.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var loginInputView: UITextField!
    
    @IBOutlet weak var passwordInputView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var didPerformSegue = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didPerformSegue = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginInputView.delegate = self
        passwordInputView.delegate = self
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if !didPerformSegue {
//            self.performSegue(withIdentifier: "SignedIn", sender: nil)
//            didPerformSegue = true
//        }
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
}
