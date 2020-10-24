//
//  DropDownMenu.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import UIKit

extension ChatsFolderViewController {
    //    @IBAction func chatsButtonTapped(_ sender: UIButton) {
    //        if sender.isSelected {
    //            hideDropDownMenu()
    //        } else {
    //            showDropDownMenu()
    //        }
    //    }
    //
    //    private func showDropDownMenu() {
    //        let frame = transparentView.frame
    //        UIView.animate(withDuration: 0.3) {
    //            self.transparentView.alpha = 0.5
    //            self.dropDownMenu.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: self.view.bounds.width, height: 80)
    //        }
    //
    //        titleButton.isSelected = true
    //        dropDownMenu.isScrollEnabled = false
    //    }
    //
    //    @objc internal func hideDropDownMenu() {
    //        dropDownMenu.isScrollEnabled = true
    //        let frame = transparentView.frame
    //
    //        UIView.animate(withDuration: 0.3) {
    //            self.transparentView.alpha = 0
    //            self.dropDownMenu.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: self.view.bounds.width, height: 0)
    //        } completion: { (completed) in
    //            if completed {
    //                self.titleButton.isSelected = false
    //            }
    //        }
    //    }
        
    //    private func setupDropDownMenu() {
    //        var frame = foldersView.frame
    //
    //        transparentView.frame = CGRect(
    //            x: frame.origin.x,
    //            y: frame.origin.y,
    //            width: view.bounds.width,
    //            height: view.bounds.height
    //        )
    //        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    //        transparentView.alpha = 0
    //
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropDownMenu))
    //        tapGesture.numberOfTapsRequired = 1
    //        tapGesture.numberOfTouchesRequired = 1
    //
    //        transparentView.addGestureRecognizer(tapGesture)
    //        view.addSubview(transparentView)
    //        frame = transparentView.frame
    //
    //        dropDownMenu.frame = CGRect(
    //            x: frame.origin.x,
    //            y: frame.origin.y,
    //            width: view.bounds.width,
    //            height: 0
    //        )
    //        view.addSubview(dropDownMenu)
    //
    //        dropDownMenu.delegate = self
    //        dropDownMenu.dataSource = self
    //        dropDownMenu.register(UINib(nibName: "DropDownMenuCell", bundle: nil),
    //                              forCellReuseIdentifier: "DropDownMenuCell")
    //        dropDownMenu.separatorStyle = .none
    //    }
}
