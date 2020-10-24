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
    case "Все": folderChats = ["1", "2", "3", "4", "5", "6"]
    case "Универ": folderChats = ["3", "4"]
    case "Работа": folderChats = ["5", "6"]
    default: folderChats = []
    }
    return folderChats
}
