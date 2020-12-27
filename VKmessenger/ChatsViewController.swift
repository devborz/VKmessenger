//
//  ChatsViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 24.10.2020.
//

import UIKit

class ChatsViewController: UIViewController {
    // MARK: Outlets
    
    @IBOutlet weak var foldersNamesCollectionView: UICollectionView!
    
    let foldersChatsCollectionView: CollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var navBarSeparatorLineView: UIView!
    
    // MARK: Properties
    
    var selectedChat: Chat?
    
    let toolBar = UIToolbar()
    
    var items = [UIBarButtonItem]()
    
    var folderNames = ["Все", "Работа", "Личные", "Тут", "Все", "Работа", "Личные","Все", "Работа", "Личные",]
    
    var folderName = "Все"
    
    // MARK: Constraints
    
    var sliderLeftConstraint: NSLayoutConstraint!

    var sliderRightConstraint: NSLayoutConstraint!
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatsCollectionView()
        setupFoldersCollectionView()
        setupToolBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Setup methods
    
    func setupFoldersCollectionView() {
        foldersNamesCollectionView.delegate = self
        foldersNamesCollectionView.dataSource = self
        
        foldersNamesCollectionView.register(UINib(nibName: "FolderNameCell", bundle: nil), forCellWithReuseIdentifier: "FolderCell")
        
        foldersNamesCollectionView.backgroundColor = UIColor(named: "color")
        
        foldersNamesCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
        foldersNamesCollectionView.showsHorizontalScrollIndicator = false
        
        foldersNamesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat" {
            let chatVC = segue.destination as! ChatViewController
            
            var chatName: String?
            
            switch selectedChat?.type {
            case .groupChat(let name, _, _): chatName = name
            case .privateChat(let user): chatName = user.userName
            case .none:
                return
            }
            
            guard let name = chatName else {
                return
            }
            
            chatVC.title = name
            chatVC.chatInfo = selectedChat
        }
    }
}

// MARK: ContextMenu Delegate

extension ChatsViewController: UIContextMenuInteractionDelegate {
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
