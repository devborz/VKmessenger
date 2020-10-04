//
//  NotificationSettingsController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.10.2020.
//

import UIKit

class NotificationSettingsController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var settings = [[NotificationSetting]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        fillInCells()
        view.layoutIfNeeded()
        title = "Уведомления"
        // Do any additional setup after loading the view.
    }
    
    private func addTableView() {
        tableView.separatorStyle = .none
        tableView.tableHeaderView?.tintColor = .systemGray3
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationSettingCell", bundle: nil), forCellReuseIdentifier: "NotificationSettingCell")
    }
    
    private func fillInCells() {
        let messageSettings: [NotificationSetting] = [NotificationSetting(name: "Личные сообщения", image: UIImage(systemName: "message.circle.fill")!, tintColor: .systemGray3),
                                                      NotificationSetting(name: "Групповые чаты", image: UIImage(systemName: "person.2.circle.fill")!, tintColor: .systemGray3),
                                                      NotificationSetting(name: "Сообщения сообществ", image: UIImage(systemName: "message.circle.fill")!, tintColor: .systemOrange)]
        let feedbackSettings: [NotificationSetting] = [NotificationSetting(name: "Упоминания в беседе", image: UIImage(systemName: "message.circle.fill")!, tintColor: .systemGreen)]
        let eventsSettings: [NotificationSetting] = [NotificationSetting(name: "Запросы на переписку", image: UIImage(systemName: "message.circle.fill")!, tintColor: .systemBlue)]
        settings.append(messageSettings)
        settings.append(feedbackSettings)
        settings.append(eventsSettings)
    }
}

extension NotificationSettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 12))
        returnedView.backgroundColor = .white

        let label = UILabel(frame: CGRect(x: 10, y: 1, width: view.bounds.width, height: 12))
        label.textColor = .systemGray4
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        switch section {
        case 0: label.text = "СООБЩЕНИЯ"
        case 1: label.text = "ОБРАТНАЯ СВЯЗЬ"
        case 2: label.text = "СОБЫТИЯ"
        default: label.text = nil
        }
        returnedView.addSubview(label)
        return returnedView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingCell", for: indexPath) as! NotificationSettingCell
        cell.setup(settings[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct NotificationSetting {
    var name: String
    var value: String = "not"
    var image: UIImage
    var tintColor: UIColor
}
