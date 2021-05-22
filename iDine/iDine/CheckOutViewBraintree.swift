//
//  CheckOutView.swift
//  iDine
//
//  Created by David Zimmer on 3/14/21.
//
//  Features to add
//    Make tip boxes larger
//    Make confirm order a button
//sandbox_zjxkty8n_3zn8nqpgrcyk5g36

import SwiftUI
import BraintreeDropIn

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

struct CheckOutView: View {
    @EnvironmentObject var order: Order
    @State private var paymentType = "Credit Card"
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 15
    @State private var showingPaymentAlert = false
    @State var showDropIn = false
    var tax = 0.06
    
    let token = "sandbox_zjxkty8n_3zn8nqpgrcyk5g36"
    let paymentTypes = ["Cash", "Credit Card", "iDine Payment Points"]
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
        VStack{
            Section(header: Text("Payment Options")){
                Picker("How do you want to pay?", selection: $paymentType){
                    ForEach(paymentTypes, id:\.self){
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                // I don't like this Picker
                if paymentType == "iDine Payment Points"{
                    Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
                    if addLoyaltyDetails{
                        TextField("Enter your iDine ID", text: $loyaltyNumber)
                    }
                }
            }
            
            Section(header: Text("Tip")) {
                Picker("Percentage:", selection: $tipAmount) {
                    ForEach(tipAmounts, id: \.self) {
                        Text("\($0)%")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header:
                        
                        Text("Total: \(totalPrice)")
                            .font(.largeTitle)
            ){
                ZStack{
                    VStack {
                        Text("Subtotal: \(order.cartTotal, specifier: "%.2f")")
                        Text("Tax: \(Double(order.cartTotal) *  tax, specifier: "%.2f")")
                        Text("Tip: \(Double(order.cartTotal) * (1 + tax) * (Double(tipAmount)/100), specifier: "%.2f")").padding()
                        
                        Button("Pay"){
                            // get client token
                            
                            self.showDropIn = true
                        }
                    }
                    if self.showDropIn {
                        BTDropInRepresentable(authorization: token, handler: { controller, result, error in
                            // check for error or result
                            // send tokenized payment method to your server
                            if (error != nil) {
                                        print("ERROR")
                            } else if (result?.isCanceled == true) {
                                print("CANCELED")
                            } else if let result = result {
                                // Use the BTDropInResult properties to update your UI
//                                let selectedPaymentMethodType = result.paymentMethodType
                                let selectedPaymentMethod = result.paymentMethod
                                if (selectedPaymentMethod != nil) {
                                    order.nonce = selectedPaymentMethod?.nonce ?? ""
                                }
//                                self.paymentMethod = result.paymentMethod
//                                let selectedPaymentMethodIcon = result.paymentIcon
//                                let selectedPaymentMethodDescription = result.paymentDescription

                                placeOrder(paymentMethodNonce: selectedPaymentMethod!.nonce)
                            }
                            controller.dismiss(animated: true, completion: nil)
                            // send nonce
                            
                            self.showDropIn = false
                        }).edgesIgnoringSafeArea(.vertical)
                    }
                }
                Button("Confirm Order"){
                    showingPaymentAlert.toggle()
                }
            }
            
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order Confirmed"), message: Text("Your total was  \(totalPrice)"), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder(paymentMethodNonce: String) {
        // Update URL with your server
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
//        print("in post nonce")
//        print(paymentMethodNonce)
//        print("nonce above")
        
        
        let url = "http://127.0.0.1:5000/checkouts"
        let paymentURL = URL(string: url)!
        var request = URLRequest(url: paymentURL)
//        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
        }.resume()
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView()
            .environmentObject(Order())
    }
}
