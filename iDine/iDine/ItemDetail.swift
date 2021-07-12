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
    @State private var sizeSelector = 0
//    var sizePickerVisible = true
    let item: ItemType
    
    var body: some View {
        VStack{
            Spacer()
            VStack {
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
            Spacer().frame(minHeight: 15, maxHeight: 30)
//            if item.items.count < 2 {
//                sizePickerVisible == false
//            }
            Picker("Size: \(item.items[0].nickname)", selection: $sizeSelector) {
                ForEach(0..<item.items.count, id: \.self) {
                    Text(self.item.items[$0].nickname)
                }
            }//.frame(height: 0)//(sizePickerVisible() ? nil : 0))
            .pickerStyle(SegmentedPickerStyle())
            .padding()//.font(.headline).background(Color.red).foregroundColor(.white).clipShape(Capsule())
            .opacity(sizePickerVisible() ? 1 : 0)
            .frame(height: (sizePickerVisible() ? nil : 0))
//            Text("\(item.items[sizeSelector].name)")
            
            HStack {
                Picker("Quantity: \(quantity)", selection: $quantity) {
                        ForEach(0 ..< 20) {
                            Text("\($0)")
                        }.navigationTitle(Text("Size Selection"))
                }.pickerStyle(MenuPickerStyle()).padding().font(.headline).background(Color.red).foregroundColor(.white).clipShape(Capsule())
                Button("Add To Cart"){
                    order.add(item: item.items[sizeSelector], quantity: quantity)
                }.padding().font(.headline).background(Color.red).foregroundColor(.white).clipShape(Capsule())
            }
            
            Spacer()
        }.navigationTitle(item.name).navigationBarTitleDisplayMode(.inline)
    }
    
    func sizePickerVisible() -> Bool {
//        print("hit func")
        if item.items.count < 2 {
            return false
        } else {
            return true
        }
    }
}

//struct ItemDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            ItemDetail(item: MenuItem.example)
//                .environmentObject(Order())
//        }
//    }
//}
