//
//  NotificationSettingsController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.10.2020.
//

import UIKit

class NotificationSettingsController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(named: "color")
        return tableView
    }()
    
    var settings = [[NotificationSetting]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "color")
        fillInCells()
        addTableView()
        title = "Уведомления"
    }
    
    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func fillInCells() {
        let messageSettings: [NotificationSetting] = [
            NotificationSetting(name: "Личные сообщения", imageName: "message.circle.fill", tintColor: .systemGray),
            NotificationSetting(name: "Групповые чаты", imageName: "person.2.circle.fill", tintColor: .systemGray),
            NotificationSetting(name: "Сообщения сообществ", imageName: "message.circle.fill", tintColor: .brown)]
        let feedbackSettings: [NotificationSetting] = [NotificationSetting(name: "Упоминания в беседе", imageName: "message.circle.fill", tintColor: .green)]
        let eventsSettings: [NotificationSetting] = [NotificationSetting(name: "Запросы на переписку", imageName: "message.circle.fill", tintColor: .blue
        )]
        settings.append(messageSettings)
        settings.append(feedbackSettings)
        settings.append(eventsSettings)
    }
}

extension NotificationSettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 34))
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: view.bounds.width, height: 14))
        
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        switch section {
        case 0: label.text = "СООБЩЕНИЯ"
        case 1: label.text = "ОБРАТНАЯ СВЯЗЬ"
        case 2: label.text = "СОБЫТИЯ"
        default: label.text = nil
        }
        
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor(named: "color")
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NotificationCell")
        cell.imageView?.image = UIImage(systemName:  settings[indexPath.section][indexPath.row].imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        cell.imageView?.tintColor = settings[indexPath.section][indexPath.row].tintColor
        cell.textLabel?.text = settings[indexPath.section][indexPath.row].name
        cell.detailTextLabel?.text = settings[indexPath.section][indexPath.row].value
        cell.backgroundColor = UIColor(named: "color")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

struct NotificationSetting {
    var name: String
    var value: String = "not"
    var imageName: String
    var tintColor: UIColor
}
