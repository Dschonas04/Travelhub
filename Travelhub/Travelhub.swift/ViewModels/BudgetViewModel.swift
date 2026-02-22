//
//  BudgetViewModel.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData
import Observation

@Observable
class BudgetViewModel {
    var selectedTripId: String = ""
    
    func getExpensesForTrip(tripId: String, from expenses: [BudgetExpense]) -> [BudgetExpense] {
        expenses.filter { $0.tripId == tripId }
            .sorted { $0.date > $1.date }
    }
    
    func getTotalExpenses(from expenses: [BudgetExpense]) -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    func addExpense(_ expense: BudgetExpense, modelContext: ModelContext) {
        modelContext.insert(expense)
        try? modelContext.save()
    }
    
    func deleteExpense(_ expense: BudgetExpense, modelContext: ModelContext) {
        modelContext.delete(expense)
        try? modelContext.save()
    }
    
    func calculateSplitAmount(expense: BudgetExpense) -> Double {
        guard !expense.splitWith.isEmpty else { return 0 }
        return expense.amount / Double(expense.splitWith.count + 1) // +1 for payer
    }
}

