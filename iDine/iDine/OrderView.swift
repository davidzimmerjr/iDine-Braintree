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
        let _items = order.items
        let counts = _items.reduce(into: [:]) { counts, item in counts[item, default: 0] += 1 }
        
        NavigationView {
            List {
                Section {
                    
                    ForEach(Array(counts.keys), id: \.self){ key in
                        HStack {
                            Text("\(counts[key] ?? 0)")
                                .frame(width: 20, alignment: .trailing)
                            Spacer()
                                .frame(width: 15)
                            Image(key.thumbnailImage)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.red, lineWidth: 2))
                                .frame(alignment: .leading)
                            Text(key.name)
                            Spacer()
                            Text("$\(key.price * Double(counts[key] ?? 0), specifier: "%.2f")")
                        }
                    }.onDelete(perform: deleteItems)
                }
                
                Section{
                    NavigationLink(destination: CheckOutView()){
                        Spacer()
                        Text("Place Order")
                            .foregroundColor(.white)
                            .font(Font.headline.weight(.black))
                        Spacer()
                    }
                }.disabled(order.items.isEmpty)
                .listRowBackground(Color.red)
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
