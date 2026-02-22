//
//  ExpenseRowView.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import SwiftUI
// Uses BudgetCategoryStyle for consistent category visuals

struct ExpenseRowView: View {
    let expense: BudgetExpense
    
    var categoryColor: Color { BudgetCategoryStyle.color(for: expense.category) }
    
    var categoryIcon: String { BudgetCategoryStyle.icon(for: expense.category) }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: categoryIcon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(categoryColor)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.expenseDescription)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("Paid by \(expense.paidBy)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("€\(expense.amount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.appText)
                
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

