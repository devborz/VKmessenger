//
//  SearchViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 27.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        navigationItem.titleView = searchBar
        
        searchBar?.delegate = self
        searchBar?.becomeFirstResponder()
        
        searchBar?.showsCancelButton = true
        searchBar?.showsScopeBar = true
        
        if let cancelButton = searchBar?.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отменить", for: .normal)
        }
        
        searchBar?.scopeButtonTitles = ["Чаты", "Сообщения"]
        searchBar?.scopeBarBackgroundImage = UIImage().withTintColor(.systemBackground)
        
        searchBar?.placeholder = "Поиск"
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
