//
//  OrderView.swift
//  iDine
//
//  Created by David Zimmer on 3/13/21.
//
//  Features to add
//    Show quantity and plus and minus signs on either side.
//      Click on number and keyboard comes up
//    Show picture inline of food
//    Make "Place Order" a button at the bottom of this


import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: Order
    @State private var quantitySelector = 2
    
    var body: some View {
        let orderItems = order.items
        let itemsQuantity = order.itemQuantity
//        let orderCounts = orderItems.reduce(into: [:]) { counts, item in counts[item, default: 0] += 1 }

        NavigationView {
            List {
                Section {
//                    let _items = condenseItems(items: orderItems, dict: orderCounts)
                    ForEach(0..<orderItems.count, id: \.self) { index in
                        HStack {
                            let message = "\(itemsQuantity[index]) ▾"
                            Picker(message, selection: $order.itemQuantity[index]) {//$quantitySelector) {
//                                updateQuantity(quantity: quantitySelector, index: index)
                                ForEach(0 ..< 20) {
                                    Text("\($0)")
                                }
//                                order.itemQuantity = quantitySelector
                            }.pickerStyle(MenuPickerStyle())
                            Spacer()
                            Image(orderItems[index].thumbnailImage).clipShape(Circle())
                                .overlay(Circle()
                                .stroke(Color.red, lineWidth: 2))
                                .frame(alignment: .leading)
                            Spacer().frame(width: 15)
                            Text(orderItems[index].name)
                            Spacer()
                            Text("$\(orderItems[index].price * Double(itemsQuantity[index]), specifier: "%.2f")")
                            
                            
                            
                        }
                        
                            
                            
//                        HStack {
//                            Text(itemsQuantity)
//                                .frame(width: 20, alignment: .trailing)
//                            Spacer()
//                                .frame(width: 15)
//                            Image(_items.thumbnailImage)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.red, lineWidth: 2))
//                                .frame(alignment: .leading)
//                            Text(_items.name)
//                            Spacer()
//                            Text("$\(_items.price * Double(orderCounts[_items] ?? 0), specifier: "%.2f")")
//                        }
                    }//.onDelete(perform: deleteItems)
                }
                Section{
                    NavigationLink(
                        destination: CheckOutView()){
                            Text("Place Order")
                    }
                }.disabled(order.items.isEmpty)
            }
            .navigationTitle("Order")
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    
//    func deleteItems(at offsets: IndexSet){
//        order.items.remove(atOffsets: offsets)
//    }
    
//    func condenseItems(items: Array<MenuItem>, dict: Dictionary<MenuItem, Int>) -> [MenuItem]{
//        var condensedArray = [MenuItem]()
//
//        for item in items {
//            if !condensedArray.contains(item) {
//                condensedArray.append(item)
//            }
//        }
//
//        return condensedArray
//    }
    
    func updateQuantity(quantity: Int, index: Int) {
        order.itemQuantity[index] = quantity
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(Order())
    }
}
