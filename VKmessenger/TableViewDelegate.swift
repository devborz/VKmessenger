//
//  TableViewDelegate.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.10.2020.
//

import UIKit

extension ChatsMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == chatsTableView {
            let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            cell.setup(
                visibleChats[indexPath.row][0],
                chatImage: UIImage(), chatName:
                visibleChats[indexPath.row][1], lastMessage:
                visibleChats[indexPath.row][2], lastTime:
                visibleChats[indexPath.row][3]
            )
            return cell
        } else {
            let cell = dropDownMenu.dequeueReusableCell(withIdentifier: "ChatMenuCell") as! ChatMenuCell
            cell.cellNameLabel.text = indexPath.row == 0 ? "Все чаты" : "Непрочитанные"
            cell.cellImageView.image = indexPath.row == 0 ? UIImage(systemName: "message") : UIImage(systemName: "plus.message")
            if indexPath.row == 0 {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                selectedRow = indexPath
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChat = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "GoToChat", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { _,_,_ in
            self.visibleChats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
