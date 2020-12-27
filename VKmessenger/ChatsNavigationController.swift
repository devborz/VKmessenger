//
//  ChatsNavigationController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.11.2020.
//

import UIKit

class ChatsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor(named: "color")
        navigationBar.isTranslucent = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {

        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }

        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        if let topVC = viewControllers.last {
            return topVC.prefersStatusBarHidden
        }
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

}
