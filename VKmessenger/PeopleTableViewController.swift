//
//  PeopleTableViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.10.2020.
//

import UIKit


class PeopleTableViewController: UITableViewController {
    
    struct TableCell {
        var text: String
        var imageName: String
        var detailText: String?
    }
    
    var cells = [TableCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        getCells()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }
    
    private func getCells() {
        cells.append(TableCell(text: "Найти людей рядом", imageName: "mappin.and.ellipse", detailText: nil))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = cells[indexPath.row].text
        cell.detailTextLabel?.text = cells[indexPath.row].detailText
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        cell.imageView?.image = UIImage(systemName: cells[indexPath.row].imageName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            self.performSegue(withIdentifier: "GoToPeopleNearby", sender: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
