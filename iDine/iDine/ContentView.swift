//  https://www.hackingwithswift.com/quick-start/swiftui/presenting-an-alert
//  Opt-Cmd-P will make your SwiftUI preview update
//  ContentView.swift
//  iDine
//
//  Created by David Zimmer on 3/10/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
        
        NavigationView{
            List{
                ForEach(menu){ section in
                    Section(header: Text(section.name)){
                        ForEach(section.items){ item in
                            NavigationLink(destination: ItemDetail(item: item)){
                                ItemRow(item: item).padding()
                            }
                        }
                    }
                }
            }.navigationTitle("Menu").listStyle(GroupedListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}
