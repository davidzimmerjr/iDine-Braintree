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
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(order.items){ item in
                        HStack {
                            Image(item.thumbnailImage)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.red, lineWidth: 2))
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price, specifier: "%.2f")")
                            Spacer()
                        }
                    }.onDelete(perform: deleteItems)
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
            .toolbar{
                EditButton()
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet){
        order.items.remove(atOffsets: offsets)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(Order())
    }
}
