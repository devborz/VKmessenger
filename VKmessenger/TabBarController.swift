//
//  TabBarController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.10.2020.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        self.view.backgroundColor = .systemBackground
        
        for item in tabBar.items! {
            item.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "PingFangTC-Semibold", size: 11)], for: .normal)
        }
    }
}
