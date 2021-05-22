//
//  MainView.swift
//  iDine
//
//  Created by David Zimmer on 3/14/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem { Label("Menu", systemImage: "list.bullet") }
            
            OrderView()
                .tabItem { Label("Cart", systemImage: "cart") }
            // These are called SF Symbols
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Order())
    }
}
