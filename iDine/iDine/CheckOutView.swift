////
////  CheckOutView.swift
////  iDine
////
////  Created by David Zimmer on 3/14/21.
////
////  Features to add
////    Make tip boxes larger
////    Make confirm order a button
////sandbox_zjxkty8n_3zn8nqpgrcyk5g36
//
//import SwiftUI
//
//
//struct CheckOutView: View {
//    @EnvironmentObject var order: Order
//    @State private var paymentType = "Credit Card"
//    @State private var addLoyaltyDetails = false
//    @State private var loyaltyNumber = ""
//    @State private var tipAmount = 15
//    @State private var showingPaymentAlert = false


//    let paymentTypes = ["Cash", "Credit Card", "iDine Payment Points"]
//    let tipAmounts = [10, 15, 20, 25, 0]
//
//    var totalPrice: String{
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//
//        let total = Double(order.total)
//        let tipValue = Double(tipAmount) / 100 * total
//
//        return formatter.string(from: NSNumber(value: total + tipValue)) ?? "$0"
//    }
//
//    var body: some View {
//        Form{
//            Section(header: Text("Payment Options")){
//                Picker("How do you want to pay?", selection: $paymentType){
//                    ForEach(paymentTypes, id:\.self){
//                        Text($0)
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
//                // I don't like this Picker
//                if paymentType == "iDine Payment Points"{
//                    Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
//                    if addLoyaltyDetails{
//                        TextField("Enter your iDine ID", text: $loyaltyNumber)
//                    }
//                }
//            }
//
//            Section(header: Text("Tip")) {
//                Picker("Percentage:", selection: $tipAmount) {
//                    ForEach(tipAmounts, id: \.self) {
//                        Text("\($0)%")
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
//            }
//            Section(header:
//                        Text("Total: \(totalPrice)")
//                            .font(.largeTitle)
//            ){
//                }
//                Button("Confirm Order"){
//                    showingPaymentAlert.toggle()
//                }
//            }
//
//        }
//        .navigationTitle("Payment")
//        .navigationBarTitleDisplayMode(.inline)
//        .alert(isPresented: $showingPaymentAlert) {
//            Alert(title: Text("Order Confirmed"), message: Text("Your total was  \(totalPrice)"), dismissButton: .default(Text("OK")))
//        }
//    }
//}
//
//struct CheckOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckOutView()
//            .environmentObject(Order())
//    }
//}
