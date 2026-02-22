//
//  ExpenseRowView.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: BudgetExpense
    
    var categoryColor: Color {
        switch expense.category {
        case "Food": return Color.orange
        case "Transport": return Color.red
        case "Accommodation": return Color.purple
        case "Activities": return Color.green
        default: return Color.blue
        }
    }
    
    var categoryIcon: String {
        switch expense.category {
        case "Food": return "fork.knife"
        case "Transport": return "car.fill"
        case "Accommodation": return "house.fill"
        case "Activities": return "star.fill"
        default: return "creditcard.fill"
        }
    }
    
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
                    .foregroundColor(.black)
                
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
