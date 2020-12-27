//
//  ChatDropDownMenu.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.11.2020.
//

import UIKit

struct ChatMenuOption {
    var name: String
    var imageName: String
    var action: (()->Void)?
}

class ChatDropDownMenuView: UIView {
    
    var chatType: ChatType!
    
    var privateChatMenuOptions: [ChatMenuOption] {
        let chatMenuOptions: [ChatMenuOption] = [
            ChatMenuOption(name: "Открыть профиль", imageName: "person.crop.circle", action: {
                self.delegate?.didSelectOptionOpenProfile()
            }),
            ChatMenuOption(name: "Добавить в беседу", imageName: "plus.message", action: {
                self.delegate?.didSelectOptionAddToChat()
            }),
            ChatMenuOption(name: "Поиск сообщений", imageName: "magnifyingglass", action: {
                self.delegate?.didSelectOptionSearch()
            }),
            ChatMenuOption(name: "Показать вложения", imageName: "photo", action: {
                self.delegate?.didSelectOptionShowAttachments()
            }),
            ChatMenuOption(name: "Отключить уведомления", imageName: "volume.slash", action: {
                self.delegate?.didSelectOptionMute()
            }),
            ChatMenuOption(name: "Очистить историю", imageName: "trash", action: {
                self.delegate?.didSelectOptionClearHistory()
            }),
        ]
        return chatMenuOptions
    }
    
    var groupChatMenuOptions: [ChatMenuOption] {
        let chatMenuOptions: [ChatMenuOption] = [
            ChatMenuOption(name: "Добавить участников", imageName: "plus.message", action: {
                self.delegate?.didSelectOptionAddPeople()
            }),
            ChatMenuOption(name: "Поиск сообщений", imageName: "magnifyingglass", action: {
                self.delegate?.didSelectOptionSearch()
            }),
            ChatMenuOption(name: "Показать вложения", imageName: "photo", action: {
                self.delegate?.didSelectOptionShowAttachments()
            }),
            ChatMenuOption(name: "Отключить уведомления", imageName: "volume.slash", action: {
                self.delegate?.didSelectOptionMute()
            })
        ]
        return chatMenuOptions
    }
    
    var transparentView = UIView()
    
    var dropdownMenuTableView = UITableView()
    
    var dropdownMenu = UIView()
    
    var dropdownMenuHeightConstraint: NSLayoutConstraint?
    
    var delegate: ChatDropDownMenuViewDelegate?
    
    var dataSource: ChatDropDownMenuViewDataSource? {
        didSet {
            titleView = dataSource?.titleView()
            chatType = dataSource?.chatType()
        }
    }
    
    var titleView: ChatTitleView?
    
    var numberOfRows: Int?
    
    var rowHeight: CGFloat = 45 {
        didSet {
            dropdownMenuTableView.rowHeight = rowHeight
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupTransaparentView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        dropdownMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatMenuCell")
        
        dropdownMenuTableView.separatorStyle = .none
        dropdownMenuTableView.isScrollEnabled = false
        dropdownMenuTableView.rowHeight = rowHeight
        
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        dropdownMenuTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dropdownMenu)
        
        dropdownMenu.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dropdownMenu.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dropdownMenu.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dropdownMenuHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: 0)
        dropdownMenuHeightConstraint?.isActive = true
        
        dropdownMenuTableView.delegate = self
        dropdownMenuTableView.dataSource = self
        dropdownMenu.addSubview(dropdownMenuTableView)
        
        dropdownMenuTableView.topAnchor.constraint(equalTo: dropdownMenu.topAnchor).isActive = true
        dropdownMenuTableView.leftAnchor.constraint(equalTo: dropdownMenu.leftAnchor).isActive = true
        dropdownMenuTableView.rightAnchor.constraint(equalTo: dropdownMenu.rightAnchor).isActive = true
        dropdownMenuTableView.bottomAnchor.constraint(equalTo: dropdownMenu.bottomAnchor).isActive = true
        
        self.layoutIfNeeded()
    }
    
    func setupTransaparentView() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTransparentView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        transparentView.addGestureRecognizer(tapGesture)
        self.addSubview(transparentView)
        
        transparentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        transparentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        transparentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        transparentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @objc func didTapTransparentView() {
        titleView?.isSelected = false
        delegate?.didTapTransparentView()
    }
    
    func show() {
        var rowsCount = 0
        
        switch chatType {
        case .privateChat: rowsCount = privateChatMenuOptions.count
        case .groupChat: rowsCount = groupChatMenuOptions.count
        case .none: rowsCount = 0
        }
        
        guard rowsCount > 0 else { return }
        
        dropdownMenuTableView.scrollToRow(at: IndexPath(row: rowsCount - 1, section: 0), at: .bottom, animated: true)
                                          
        dropdownMenuHeightConstraint?.constant = CGFloat(rowsCount) * rowHeight

        titleView?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0.5
            self.layoutIfNeeded()
        } completion: { completed in
            if completed {
                self.titleView?.isUserInteractionEnabled = true
            }
        }
    }

    func hide() {
        dropdownMenuHeightConstraint?.constant = 0
        
        titleView?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0
            self.layoutIfNeeded()
        } completion: { (completed) in
            if completed {
                self.titleView?.isUserInteractionEnabled = true
                self.removeFromSuperview()
            }
        }
    }
}

extension ChatDropDownMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch chatType {
        case .privateChat: return privateChatMenuOptions.count
        case .groupChat: return groupChatMenuOptions.count
        case .none: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var menuOption: ChatMenuOption!
        
        switch chatType {
        case .privateChat: menuOption = privateChatMenuOptions[indexPath.row]
        case .groupChat: menuOption = groupChatMenuOptions[indexPath.row]
        case .none: break
        }
        
        guard let option = menuOption else {
            return UITableViewCell(style: .default, reuseIdentifier: "ChatMenuCell")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMenuCell", for: indexPath)
        cell.textLabel?.text = option.name
        cell.imageView?.image = UIImage(systemName: option.imageName)
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch chatType {
        case .privateChat: privateChatMenuOptions[indexPath.row].action!()
        case .groupChat: groupChatMenuOptions[indexPath.row].action!()
        case .none: break
        }
    }
}

protocol ChatDropDownMenuViewDelegate {
    func didTapTransparentView()
    
    func didChangeMute()
    
    func didSelectOptionClearHistory()
    
    func didSelectOptionOpenProfile()
    
    func didSelectOptionAddToChat()
    
    func didSelectOptionShowAttachments()
    
    func didSelectOptionSearch()
    
    func didSelectOptionMute()
    
    func didSelectOptionAddPeople()
}

protocol ChatDropDownMenuViewDataSource {
    
    func isChatMuted() -> Bool
    
    func titleView() -> ChatTitleView
    
    func chatType() -> ChatType
}
