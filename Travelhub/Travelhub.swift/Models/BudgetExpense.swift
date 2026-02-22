//
//  BudgetExpense.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

@Model
final class BudgetExpense {
    // Use UUID for stable identity in SwiftData; avoid `let` stored properties
    @Attribute(.unique) var id: UUID = UUID()
    var tripId: String
    var expenseDescription: String
    var amount: Double
    var paidBy: String
    var category: String = "General" // "Food", "Transport", "Accommodation", "Activities", "General"
    var splitWith: [String] = [] // Member IDs
    var date: Date = Date()

    init(tripId: String, expenseDescription: String, amount: Double, paidBy: String, category: String = "General", splitWith: [String] = [], date: Date = Date()) {
        self.tripId = tripId
        self.expenseDescription = expenseDescription
        self.amount = amount
        self.paidBy = paidBy
        self.category = category
        self.splitWith = splitWith
        self.date = date
    }
}

import SwiftUI

struct BudgetExpensePrototypeView: View {
    @State private var tripId = "TRIP123"
    @State private var expenseDescription = "Dinner at Beach Club"
    @State private var amount: Double = 42.5
    @State private var paidBy = "Max"
    @State private var category = "Food"
    @State private var splitWith: [String] = ["Max", "Lena", "Jonas"]
    @State private var date = Date()

    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                TextField("Trip ID", text: $tripId)
                TextField("Description", text: $expenseDescription)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Paid by", text: $paidBy)
                Picker("Category", selection: $category) {
                    Text("Food").tag("Food")
                    Text("Transport").tag("Transport")
                    Text("Accommodation").tag("Accommodation")
                    Text("Activities").tag("Activities")
                    Text("General").tag("General")
                }
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            Section(header: Text("Split With")) {
                ForEach(splitWith, id: \.self) { member in
                    Text(member)
                }
                Button("Add Member") {
                    splitWith.append("New Member")
                }
            }
            Section(header: Text("Summary")) {
                Text("ID: \(UUID().uuidString.prefix(8))")
                Text("Trip: \(tripId)")
                Text("Description: \(expenseDescription)")
                Text("Amount: €\(amount, specifier: "%.2f")")
                Text("Paid by: \(paidBy)")
                Text("Category: \(category)")
                Text("Date: \(date, formatter: dateFormatter)")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .short
    return f
}()

#Preview {
    BudgetExpensePrototypeView()
}

