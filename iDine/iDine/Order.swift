//
//  Order.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case names, total, cartTotal, tipValue, taxValue, nonce
    }
    
    
    @Published var items = [MenuItem]()
    @Published var names = [String]()
    var nonce = ""
    var total = 0.0
    var tipValue = 0.0
    var taxValue = 0.0
    
    var cartTotal: Double {
        if items.count > 0 {
//            return 0
            return Double(items.reduce(0) { $0 + $1.price })
        } else {
            return 0
        }
    }

    func add(item: MenuItem) {
        items.append(item)
        names.append(item.name)
    }

    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        names = try container.decode([String].self, forKey: .names)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(names, forKey: .names)
        try container.encode(total, forKey: .total)
        try container.encode(cartTotal, forKey: .cartTotal)
        try container.encode(tipValue, forKey: .tipValue)
        try container.encode(taxValue, forKey: .taxValue)
        try container.encode(nonce, forKey: .nonce)
    }
    
//    #if DEBUG
//    static let example = [MenuItem]([id: UUID(), name: "Maple French Toast", photoCredit: "Joseph Gonzalez", price: 6, restrictions: ["G", "V"], description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…"],[id: UUID(), name: "Maple French Toast", photoCredit: "Joseph Gonzalez", price: 6, restrictions: ["G", "V"], description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…"])
//    #endif
}

