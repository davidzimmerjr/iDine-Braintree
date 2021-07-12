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
import BraintreeDropIn

struct OrderView: View {
    @EnvironmentObject var order: Order
    @State private var quantitySelector = 2
    
    // from COV
    @State private var paymentType = "Credit Card"
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 15
    @State private var showingPaymentAlert = false
    @State var showDropIn = false
    var tax = 0.06
    
    let token = "sandbox_zjxkty8n_3zn8nqpgrcyk5g36"
    let paymentTypes = ["Cash", "Credit Card"]
    let tipAmounts = [10, 15, 20, 25, 0]
    
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        let _cartTotal = Double(order.cartTotal)
        let tipValue = Double(tipAmount) / 100 * _cartTotal
        order.tipValue = tipValue
        let taxValue = Double(tax * Double(order.cartTotal))
        order.taxValue = taxValue
        
        let total = (_cartTotal + tipValue) * (1 + tax)
//        order.total = (total, specifier: "%.2f")
        
        return formatter.string(from: NSNumber(value: total)) ?? "$0"
    }
    
    var body: some View {
        let orderItems = order.items
        let itemsQuantity = order.itemQuantity
        ZStack {
            Color(.systemGray3).edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                        VStack {
                            HStack {
                                Text("Cart").font(.title).padding()
                                Spacer()
                            }
                            ForEach(0..<orderItems.count, id: \.self) { index in
                                VStack {
                                    HStack {
                                        let message = "\(itemsQuantity[index]) ▾"
                                        Spacer().frame(maxWidth: 35)
                                        Picker(message, selection: $order.itemQuantity[index]) {
                                            ForEach(0 ..< 20) {
                                                Text("\($0)")
                                            }
//                                            if order.itemQuantity[index] == 0 {
//                                                order.remove(item: orderItems[index])
//                                            }
                                        }.pickerStyle(MenuPickerStyle())
                                        Spacer().frame(maxWidth: 25)
//                                        Image(orderItems[index].thumbnailImage).clipShape(Circle())
                                            .overlay(Circle()
                                            .stroke(Color.red, lineWidth: 2))
                                            .frame(alignment: .leading)
                                        Spacer().frame(width: 15)
                                        Text(orderItems[index].name)
                                        Spacer()
                                        Text("$\(orderItems[index].price * Double(itemsQuantity[index]), specifier: "%.2f")")
                                        Spacer().frame(maxWidth: 35)
                                    }
                                    Divider()
                                }
                            }
                            HStack {
                                Spacer()
                                Text("Subtotal: ")
                                Spacer().frame(width: 20)
                                Text("$\(order.cartTotal, specifier: "%.2f")")
                                Spacer().frame(maxWidth: 35)
                            }
                            HStack {
                                Spacer()
                                Text("Tax:")
                                Spacer().frame(width: 20)
                                Text("$\(Double(order.cartTotal) *  tax, specifier: "%.2f")")
                                Spacer().frame(maxWidth: 35)
                            }

                        }//.border(Color.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .padding()
                }.padding(.top, 1)
                Spacer().frame(height: 10)
                VStack {
                    HStack {
                        Text("Checkout").font(.title)
                        Spacer()
                        
                    }
                    Picker("How do you want to pay?", selection: $paymentType){
                        ForEach(paymentTypes, id:\.self){
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    // I don't like this Picker
//                    if paymentType == "iDine Payment Points"{
//                        Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
//                        if addLoyaltyDetails{
//                            TextField("Enter your iDine ID", text: $loyaltyNumber)
//                        }
//                    }
                    
                    Picker("Percentage:", selection: $tipAmount) {
                        ForEach(tipAmounts, id: \.self) {
                            Text("\($0)%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Spacer().frame(height: 15)
                    ZStack{
                        VStack {
                            VStack (alignment: .trailing) {
                                HStack {
                                    Spacer()
                                    Text("Tip: $\(Double(order.cartTotal) * (1 + tax) * (Double(tipAmount)/100), specifier: "%.2f")")
                                }
                                HStack {
                                    Spacer()
                                    Text("Total: \(totalPrice)")
                                                .fontWeight(.bold)
                                }
                            }
                            Spacer().frame(height: 10)
                            Button("Place Order"){
                                self.showDropIn = true
                            }.padding().font(.headline).background(Color.red).foregroundColor(.white).clipShape(Capsule())
                        }
                        
                    }
                }.padding()
                .background(Color.white)
                .cornerRadius(25)
                .padding()
            Spacer()
            }//end VStack
            .alert(isPresented: $showingPaymentAlert) {
                Alert(title: Text("Order Confirmed"), message: Text("Your total was  \(totalPrice)"), dismissButton: .default(Text("OK")))
            }
            if self.showDropIn {
                BTDropInRepresentable(authorization: token, handler: { controller, result, error in
                    if (error != nil) {
                                print("ERROR")
                    } else if (result?.isCanceled == true) {
                        print("CANCELED")
                    } else if let result = result {
                        let selectedPaymentMethod = result.paymentMethod
                        if (selectedPaymentMethod != nil) {
                            order.nonce = selectedPaymentMethod?.nonce ?? ""
                        }
                        placeOrder(paymentMethodNonce: selectedPaymentMethod!.nonce)
                    }
                    controller.dismiss(animated: true, completion: nil)
                    // send nonce
                    
                    self.showDropIn = false
                }).edgesIgnoringSafeArea(.vertical)
            }
        }
    }//end body
    
    
    func updateQuantity(quantity: Int, index: Int, item: MenuItem) {
        if quantity == 0 {
            order.remove(item: item)
        }
        order.itemQuantity[index] = quantity
    }//end func
    
    func placeOrder(paymentMethodNonce: String) {
        // Update URL with your server
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        print(order)
        let url = "http://127.0.0.1:5000/checkouts"
        let paymentURL = URL(string: url)!
        var request = URLRequest(url: paymentURL)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
        }.resume()
    }//end func
}//end struct

struct BTDropInRepresentable: UIViewControllerRepresentable {
    var authorization: String
    var handler: BTDropInControllerHandler
    var paymentMethod : BTPaymentMethodNonce?
    
    init(authorization: String, handler: @escaping BTDropInControllerHandler) {
        self.authorization = authorization
        self.handler = handler
    }
    
    func makeUIViewController(context: Context) -> BTDropInController {
        let bTDropInController = BTDropInController(authorization: authorization, request: BTDropInRequest(), handler: handler)!
        return bTDropInController
    }
    
    func updateUIViewController(_ uiViewController: BTDropInController, context: UIViewControllerRepresentableContext<BTDropInRepresentable>) {
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(Order())
    }
}
