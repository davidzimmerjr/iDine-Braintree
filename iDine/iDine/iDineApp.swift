//
//  iDineApp.swift
//  iDine
//
//  Created by David Zimmer on 3/10/21.
//

import SwiftUI

@main
struct iDineApp: App {
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(order)
        }
    }
}
