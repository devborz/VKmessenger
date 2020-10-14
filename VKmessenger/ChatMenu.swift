//
//  ChatDropDownMenu.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import UIKit

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func setupDropDownMenu() {
        setupInputBarTransparentView()
        setupTransaparentView()
        
        view.addSubview(dropdownMenu)
        
        dropdownMenuTable.delegate = self
        dropdownMenuTable.dataSource = self
        dropdownMenuTable.register(UINib(nibName: "ChatMenuCell", bundle: nil), forCellReuseIdentifier: "ChatMenuCell")
        
        dropdownMenuTable.separatorStyle = .none
        dropdownMenuTable.isScrollEnabled = false
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = dropdownMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftConstraint = dropdownMenu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let rightConstraint = dropdownMenu.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        dropdownMenuHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, dropdownMenuHeightConstraint!])
        view.layoutIfNeeded()
    }
    
    private func setupTransaparentView() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideChatMenu))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        transparentView.addGestureRecognizer(tapGesture)
        view.addSubview(transparentView)
        
        let topConstraint = transparentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftConstraint = transparentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let rightConstraint = transparentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let bottomConstraint = transparentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        view.layoutIfNeeded()
    }
    
    private func setupInputBarTransparentView() {
        inputBarTransparentView.translatesAutoresizingMaskIntoConstraints = false
        inputBarTransparentView?.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        inputBarTransparentView?.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideChatMenu))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        inputBarTransparentView?.addGestureRecognizer(tapGesture)
        messageInputBar.addSubview(inputBarTransparentView!)
        
        let topConstraint = inputBarTransparentView?.topAnchor.constraint(equalTo: messageInputBar.topAnchor)
        let leftConstraint = inputBarTransparentView?.leftAnchor.constraint(equalTo: messageInputBar.leftAnchor)
        let rightConstraint = inputBarTransparentView?.rightAnchor.constraint(equalTo: messageInputBar.rightAnchor)
        let bottomConstraint = inputBarTransparentView?.bottomAnchor.constraint(equalTo: messageInputBar.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint!, leftConstraint!, rightConstraint!, bottomConstraint!])
    }
    
    internal func showChatMenu() {
        dropdownMenuTable.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
        dropdownMenuHeightConstraint?.constant = 270
        
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0.5
            self.inputBarTransparentView?.alpha = 0.5
            self.view.layoutIfNeeded()
            self.titleButton.imageView?.transform = (self.titleButton.imageView?.transform.rotated(by: CGFloat(Double.pi)))!
        } completion: { completed in
            if completed {
                self.titleButton.isSelected = true
            }
        }
    }

    @objc internal func hideChatMenu() {
        dropdownMenuTable.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
        dropdownMenuHeightConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0
            self.inputBarTransparentView?.alpha = 0
            self.view.layoutIfNeeded()
            self.titleButton.imageView?.transform = (self.titleButton.imageView?.transform.rotated(by: CGFloat(Double.pi)))!
        } completion: { (completed) in
            if completed {
                self.titleButton.isSelected = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropdownMenuTable.dequeueReusableCell(withIdentifier: "ChatMenuCell", for: indexPath) as! ChatMenuCell
        cell.cellNameLabel.text = chatMenuOptions[indexPath.row].name
        cell.cellImageView.image = chatMenuOptions[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
