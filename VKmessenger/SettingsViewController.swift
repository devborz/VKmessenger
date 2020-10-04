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
        settingsTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "SettingTableViewCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        fillInSettings()
    }
    
    private func fillInSettings() {
        settings.append(Setting(name: "Уведомления", image: UIImage(systemName: "bell")!))
        settings.append(Setting(name: "Не беспокоить", image: UIImage(systemName: "nosign")!))
        settings.append(Setting(name: "Аккаунт", image: UIImage(systemName: "person")!))
        settings.append(Setting(name: "Основные", image: UIImage(systemName: "gearshape")!))
        settings.append(Setting(name: "Внешний вид", image: UIImage(systemName: "paintpalette")!))
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.setup(settings[indexPath.row])
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
    var image: UIImage
}
