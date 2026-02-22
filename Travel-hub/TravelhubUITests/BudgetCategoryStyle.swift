import SwiftUI

struct BudgetCategoryStyle {
    struct Item {
        let key: String
        let label: String
        let color: Color
        let icon: String
    }

    // Ordered list for consistent display in breakdowns
    static let ordered: [Item] = [
        Item(key: "Food",          label: "Essen",        color: .budgetOrange, icon: "fork.knife"),
        Item(key: "Transport",     label: "Transport",    color: .budgetRed,    icon: "car.fill"),
        Item(key: "Accommodation", label: "Unterkunft",   color: .budgetPurple, icon: "house.fill"),
        Item(key: "Activities",    label: "Aktivitäten",  color: .budgetGreen,  icon: "star.fill"),
        Item(key: "General",       label: "Sonstiges",    color: .budgetBlue,   icon: "creditcard.fill")
    ]

    static func color(for key: String) -> Color {
        ordered.first { $0.key == key }?.color ?? .blue
    }

    static func icon(for key: String) -> String {
        ordered.first { $0.key == key }?.icon ?? "creditcard.fill"
    }

    static func label(for key: String) -> String {
        ordered.first { $0.key == key }?.label ?? key
    }
}

