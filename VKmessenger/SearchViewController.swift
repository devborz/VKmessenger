//
//  SearchViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 27.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    let messagesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    func setupSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        searchBar.showsCancelButton = true
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отменить", for: .normal)
        }
        
        searchBar.placeholder = "Поиск"
        
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Чаты", "Сообщения"]
    }
    
    func setupMessagesTableView() {
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messagesTableView)
        
        messagesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}



class SearchInChatViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    let messagesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupMessagesTableView()
    }
    
    func setupSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        searchBar.showsCancelButton = true
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отменить", for: .normal)
        }
        
        searchBar.placeholder = "Поиск"
    }
    
    func setupMessagesTableView() {
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messagesTableView)
        
        messagesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
}

extension SearchInChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

extension SearchInChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
