//
//  ItemRow.swift
//  iDine
//
//  Created by David Zimmer on 3/10/21.
//

import SwiftUI

struct ItemRow : View {
//    let item: MenuItem
    let item: ItemType
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]

    var body: some View {
        HStack{
            Image(item.thumbnailImage)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.red, lineWidth: 2))
            VStack(alignment: .leading){
                Text(item.name).font(.headline)
//                Text("$\(item.price, specifier: "%.2f")")
            }
            
            Spacer()
            
            ForEach(item.restrictions, id: \.self){ restrictions in
                Text(restrictions)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(colors[restrictions, default: .black])
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
        }
    }
}

//struct ItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow(item: MenuItem.example)
//    }
//}
