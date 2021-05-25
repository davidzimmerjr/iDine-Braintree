//
//  ItemDetail.swift
//  iDine
//
//  Created by David Zimmer on 3/13/21.
//

import SwiftUI

struct ItemDetail: View {
    @EnvironmentObject var order: Order
    @State private var quantity = 0
    let item: MenuItem
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Image(item.mainImage)
                    .resizable()
                    .scaledToFill()
//                    .padding(2)
                Text("Photo: \(item.photoCredit)")
                    .padding(4)
//                    .background(Color.black)
                    .foregroundColor(.gray)
                    .font(.caption2)
                    .offset(x: -5, y: -5)
            }
//            ZStack{
//                VStack{
//                    Text(item.description).padding()
//                    Button("Add To Cart"){
//                        order.add(item: item)
//                    }.padding().font(.headline).background(Color.red).foregroundColor(.white).clipShape(Capsule())
//
//                }
//            }.background(Image(item.mainImage)
//                            .resizable()
//                            .scaledToFill()
//                            .edgesIgnoringSafeArea(.all))
            Text(item.description).padding()
            Picker("Select Quantity: \(quantity + 1)", selection: $quantity) {
                    ForEach(1 ..< 20) {
                        Text("\($0)")
                    }
            }.pickerStyle(MenuPickerStyle())
            Spacer()
            Spacer()
            Button("Add To Cart"){
                for _ in 0...quantity {
                    order.add(item: item)
                }
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
