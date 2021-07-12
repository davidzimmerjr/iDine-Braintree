//
//  Menu.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct MenuSection: Codable, Identifiable { //daddy-0. ex: pizza
    var id: UUID
    var name: String
    var types: [ItemType]
}


struct ItemType: Codable, Identifiable, Hashable, Equatable { //child of MenuSeciton. ex: cheese pizza
    var id: UUID
    var name: String
    let description: String
    let restrictions: [String]
    let photoCredit: String
    var items: [MenuItem]
    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }
}

struct MenuItem: Codable, Equatable, Identifiable, Hashable { //child of ItemType. ex: large cheese pizza
    let id: UUID
    let name: String
    let nickname: String
    let price: Double


//
//    #if DEBUG
//    static let example = MenuItem(id: UUID(), name: "Maple French Toast", photoCredit: "Joseph Gonzalez", price: 6, restrictions: ["G", "V"], description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…")
//    #endif
}
