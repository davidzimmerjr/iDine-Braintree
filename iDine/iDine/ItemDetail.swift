//
//  ItemDetail.swift
//  iDine
//
//  Created by David Zimmer on 3/13/21.
//

import SwiftUI

struct ItemDetail: View {
    @EnvironmentObject var order: Order
    @State private var quantity = 1
    let item: MenuItem
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Image(item.mainImage)
                    .resizable()
                    .scaledToFill()
                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .foregroundColor(.gray)
                    .font(.caption2)
                    .offset(x: -5, y: -5)
            }

            Text(item.description).padding()
            Picker("Quantity: \(quantity)", selection: $quantity) {
                    ForEach(0 ..< 20) {
                        Text("\($0)")
                    }
            }.pickerStyle(MenuPickerStyle())
            Spacer()
            Spacer()
            Button("Add To Cart"){
                order.add(item: item, quantity: quantity)
            }.padding().font(.headline).background(Color.red).foregroundColor(.white).clipShape(Capsule())
                
            
            Spacer()
        }.navigationTitle(item.name).navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ItemDetail(item: MenuItem.example)
                .environmentObject(Order())
        }
    }
}
