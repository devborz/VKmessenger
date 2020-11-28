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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginInputView.delegate = self
        passwordInputView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        self.performSegue(withIdentifier: "SignedIn", sender: nil)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
}
