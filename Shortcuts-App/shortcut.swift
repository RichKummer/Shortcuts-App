//
//  shortcut.swift
//  Shortcuts-App
//
//  Created by RichK on 12/5/20.
//

import Foundation

struct Shortcut: Decodable, Identifiable {
    let id: UUID
    let title: String
    let keys: String
}
