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
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {

        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }

        return .default
    }

}
