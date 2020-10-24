//
//  ChatsMainViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 24.10.2020.
//

import UIKit
import Tabman
import Pageboy

class ChatsMainViewController: TabmanViewController {
    
    var userID = "Me"
    
    var chatSearchController = UISearchController(searchResultsController: nil)
    
    var chatsFoldersViewControllers = [ChatsFolderViewController]()
    
    var folderNames = ["Все", "Универ", "Работа", "Семья"]
    
    let foldersBar = TMBar.ButtonBar()
    
    var selectedChat: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatsFoldersViewControllers()
        setupFoldersBar()
        setupNavigationBar()
        setupSearchBar()
    }
    
    func setupChatsFoldersViewControllers() {
        for name in folderNames {
            let vc = ChatsFolderViewController()
            vc.folderName = name
            vc.mainVC = self
            chatsFoldersViewControllers.append(vc)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage().withTintColor(UIColor(named: "BackgroundColor")!)
        navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = chatSearchController
    }
    
    private func setupFoldersBar() {
        self.dataSource = self
        self.delegate = self
        
        foldersBar.layout.transitionStyle = .progressive
        foldersBar.layout.interButtonSpacing = 20
        foldersBar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        foldersBar.backgroundView.style = .flat(color: UIColor(named: "BackgroundColor")!)
        
        foldersBar.indicator.cornerStyle = .eliptical
        foldersBar.indicator.transitionStyle = .progressive

        addBar(foldersBar, dataSource: self, at: .top)
        
        foldersBar.buttons.customize { (button) in
            let interaction = UIContextMenuInteraction(delegate: self)
            button.addInteraction(interaction)
            button.backgroundColor = UIColor(named: "BackgroundColor")
            button.layer.cornerRadius = 10
            button.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.clipsToBounds = true
        }
    }
    
    private func setupSearchBar() {
        chatSearchController.searchResultsUpdater = self
        chatSearchController.searchBar.delegate = self
        
        chatSearchController.obscuresBackgroundDuringPresentation = false
        chatSearchController.searchBar.placeholder = "Поиск"
        chatSearchController.searchBar.backgroundColor = UIColor(named: "BackgroundColor")
        chatSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.title = selectedChat?[1]
            chatVC.chatID = selectedChat?[0]
            chatVC.userID = self.userID
        }
    }
}

extension ChatsMainViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return chatsFoldersViewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return chatsFoldersViewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = folderNames[index]
        let item = TMBarItem(title: title)
        return item
    }
}

extension ChatsMainViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let index = 0
        
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
          identifier: identifier,
          previewProvider: nil) { _ in
            let configureFolderAction = UIAction(
              title: "Настроить папку",
              image: UIImage(systemName: "square.and.pencil")) { _ in
            }
            
            let addChatsAction = UIAction(
              title: "Добавить чаты",
              image: UIImage(systemName: "plus")) { _ in
            }
            
            let removeAction = UIAction(
              title: "Убрать",
              image: UIImage(systemName: "trash"),
              attributes: .destructive) { _ in
            }
        
            return UIMenu(title: "", image: nil, children: [configureFolderAction, addChatsAction, removeAction])
        }
    }
}

extension ChatsMainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
