//
//  LaunchAnimationViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 02.12.2020.
//

import UIKit

class LaunchAnimationViewController: UIViewController {

    @IBOutlet weak var logoImageViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateLogo {
                self.performSegue(withIdentifier: "ToAuthorization", sender: self)
            }
        }
        
    }
    
    func animateLogo(_ completion: @escaping () -> Void) {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.logoImageViewWidthConstraint.constant = 250
//            self.view.layoutIfNeeded()
//        }, completion: { _ in
            completion()
//        })
    }
    
    
}
