//
//  StartCommunicationViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 02.10.2020.
//

import UIKit

class StartCommunicationViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(cancelTapped(_:)))
    }
    
    @objc
    func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
