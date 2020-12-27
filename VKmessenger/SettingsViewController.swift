//
//  SettingsViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 02.10.2020.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settings = [Setting]()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInSettings()
        setupTableView()
        setupProfileView()
    }
    
    private func setupProfileView() {
        avatarImageView.layer.cornerRadius = 10
    }
    
    private func setupTableView() {
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView()
    }
    
    private func fillInSettings() {
        settings.append(Setting(name: "Уведомления", imageName: "bell"))
        settings.append(Setting(name: "Не беспокоить", imageName: "nosign"))
                        settings.append(Setting(name: "Аккаунт", imageName: "person"))
        settings.append(Setting(name: "Основные", imageName: "gearshape"))
        settings.append(Setting(name: "Внешний вид", imageName: "paintpalette"))
    }
    
    
    @IBAction func didTapSignOutButton(_ sender: Any) {
        tabBarController?.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text =
            settings[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(systemName: settings[indexPath.row].imageName)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch settings[indexPath.row].name {
        case "Уведомления":
            let vc = NotificationSettingsController()
            navigationController?.pushViewController(vc, animated: true)
        case "Не беспокоить":
            let vc = DoNotDisturbController()
            navigationController?.pushViewController(vc, animated: true)
        case "Аккаунт":
            let vc = AccountSettingsController()
            navigationController?.pushViewController(vc, animated: true)
        case "Основные":
            let vc = MainSettingsController()
            navigationController?.pushViewController(vc, animated: true)
        case "Внешний вид":
            let vc = AppearanceSettingsController()
            navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
}

struct Setting {
    var name: String
    var imageName: String
}
