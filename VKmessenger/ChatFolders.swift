//
//  ChatFolders.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.10.2020.
//

import Foundation

func chatsOfFolderIDs(name: String) -> [String] {
    var folderChats = [String]()
    switch name {
    case "Все": folderChats = ["1", "2", "3"]
    case "Работа": folderChats = ["1"]
    case "Личные": folderChats = ["3", "2"]
    default: folderChats = []
    }
    return folderChats
}
