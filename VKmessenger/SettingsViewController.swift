//
//  SettingsViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 02.10.2020.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settings = [Setting]()
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInSettings()
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorStyle = .none
    }
    
    private func fillInSettings() {
        settings.append(Setting(name: "Уведомления", imageName: "bell"))
        settings.append(Setting(name: "Не беспокоить", imageName: "nosign"))
                        settings.append(Setting(name: "Аккаунт", imageName: "person"))
        settings.append(Setting(name: "Основные", imageName: "gearshape"))
        settings.append(Setting(name: "Внешний вид", imageName: "paintpalette"))
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: settings[indexPath.row].imageName)
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var segueID: String?
        switch settings[indexPath.row].name {
        case "Уведомления": segueID = "Notifications" 
        case "Не беспокоить": segueID = "DoNotDisturb"
        case "Аккаунт": segueID = "Account"
        case "Основные": segueID = "Main"
        case "Внешний вид": segueID = "Appearance"
        default: segueID = nil
        }
        if let id = segueID {
            self.performSegue(withIdentifier: id, sender: nil)
        }
    }
}

struct Setting {
    var name: String
    var imageName: String
}
