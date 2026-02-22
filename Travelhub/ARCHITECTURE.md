# 🏗️ Architecture Guide - Travel Hub

## Überblick

Travel Hub folgt einer **MVVM-Architektur (Model-View-ViewModel)** mit **SwiftData** für Persistierung und **SwiftUI** für UI.

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer (SwiftUI)                   │
│  Views, Buttons, Forms, Navigation, Animations         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────┐
│            ViewModel Layer (Observable)                 │
│  State Management, Business Logic, @Query Bindings      │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────┐
│           Model Layer (SwiftData Models)                │
│  Trip, Friend, ChatMessage, BudgetExpense, Poll...      │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────┐
│            Data Persistence Layer                       │
│  SwiftData → Local Database → iOS Device Storage        │
└─────────────────────────────────────────────────────────┘
```

---

## File Structure

```
Travelhub/
│
├── Models/                          # SwiftData Models
│   ├── User.swift                   # Benutzerdaten
│   ├── Trip.swift                   # Reisen
│   ├── Friend.swift                 # Freundesliste
│   ├── ChatMessage.swift            # Nachrichten
│   ├── BudgetExpense.swift          # Ausgaben
│   ├── RouteLocation.swift          # Route-Orte
│   ├── Poll.swift                   # Abstimmungen
│   └── Notification.swift           # Benachrichtigungen
│
├── ViewModels/                      # Business Logic
│   ├── DashboardViewModel.swift
│   ├── FriendsViewModel.swift
│   ├── TripsViewModel.swift
│   ├── ChatViewModel.swift
│   └── BudgetViewModel.swift
│
├── Views/                           # UI Layer
│   ├── MainTabView.swift            # Haupt-Navigation
│   ├── DashboardView.swift
│   ├── TripsListView.swift
│   ├── CreateTripView.swift
│   ├── TripDetailView.swift         # Mit Sub-Views
│   ├── FriendsView.swift
│   ├── AddFriendView.swift
│   ├── ChatListView.swift
│   ├── ChatView.swift
│   ├── BudgetView.swift
│   ├── VotingView.swift
│   ├── ProfileView.swift
│   └── Components/                  # Reusable Components
│       ├── TripCardView.swift
│       ├── ChatBubbleView.swift
│       ├── ExpenseRowView.swift
│       └── UserAvatarView.swift
│
├── TravelhubApp.swift               # App Entry Point
├── ContentView.swift                # Root View
│
└── Assets.xcassets/                 # Images, Colors, Icons

```

---

## Models (Datenstrukturen)

### User Model
```swift
@Model
final class User {
    var id: String
    var name: String
    var email: String
    var profileImage: String
    var bio: String
    var lastActive: Date
}
```

**Verwendung**: Aktueller Benutzer + Profile Management

### Trip Model
```swift
@Model
final class Trip {
    var id: String
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var budget: Double
    var members: [String]
    var organizer: String
    var destination: String
    var imageURL: String
    var isActive: Bool
}
```

**Verwendung**: Zentrale Datenstruktur für alle Reisen

### Friend Model
```swift
@Model
final class Friend {
    var id: String
    var friendName: String
    var friendEmail: String
    var status: String  // "pending", "accepted", "blocked"
    var addedDate: Date
    var profileImage: String
}
```

**Verwendung**: Freundelisten-Management

### ChatMessage Model
```swift
@Model
final class ChatMessage {
    var id: String
    var senderId: String
    var senderName: String
    var tripId: String
    var content: String
    var timestamp: Date
    var isRead: Bool
}
```

**Verwendung**: Gruppen-Chat pro Trip

### BudgetExpense Model
```swift
@Model
final class BudgetExpense {
    var id: String
    var tripId: String
    var description: String
    var amount: Double
    var paidBy: String
    var category: String  // Food, Transport, etc.
    var splitWith: [String]
    var date: Date
}
```

**Verwendung**: Budget-Tracking und Ausgaben

### Poll Model
```swift
@Model
final class Poll {
    var id: String
    var tripId: String
    var question: String
    var options: [String]
    var votes: [String: [String]]  // option → voter_ids
    var deadline: Date
    var createdBy: String
    var isClosed: Bool
}
```

**Verwendung**: Abstimmungen und Entscheidungen

---

## ViewModels (Business Logic)

### Pattern: Observable + @Query

```swift
@Observable
class TripsViewModel {
    @ObservationIgnored
    @Query var trips: [Trip]
    
    var activeTrips: [Trip] {
        trips.filter { /* logic */ }
    }
    
    func addTrip(_ trip: Trip, modelContext: ModelContext) {
        modelContext.insert(trip)
        try? modelContext.save()
    }
}
```

**Warum dieses Pattern?**
1. `@Observable` → SwiftUI Reactivity
2. `@Query` → Automatische Updates bei Daten-Änderungen
3. `@ObservationIgnored` → Performance
4. Computed Properties → Filtering & Sorting
5. Methods → CRUD Operations (Create, Read, Update, Delete)

### ViewModels Liste

#### DashboardViewModel
```swift
- upcomingTrips: [Trip]     // Zukünftige Trips
- activeTrips: [Trip]       // Laufende Trips
- recentMessages: [ChatMessage]
- totalBudgetPlanned: Double
```

#### FriendsViewModel
```swift
- acceptedFriends: [Friend]
- pendingRequests: [Friend]
- addFriend()
- acceptFriend()
- removeFriend()
```

#### TripsViewModel
```swift
- activeTrips: [Trip]
- upcomingTrips: [Trip]
- pastTrips: [Trip]
- addTrip()
- updateTrip()
- deleteTrip()
```

#### ChatViewModel
```swift
- messagesForTrip: [ChatMessage]
- sendMessage()
```

#### BudgetViewModel
```swift
- expensesForTrip: [BudgetExpense]
- totalExpenses: Double
- addExpense()
- deleteExpense()
- calculateSplitAmount()
```

---

## Views (UI Components)

### Tab Navigation Hierarchie

```
MainTabView (TabView mit 7 Tabs)
│
├─ DashboardView
│   ├─ TripCardView (Component)
│   └─ Navigation → TripDetailView
│
├─ TripsListView
│   ├─ TripCardView (Component)
│   ├─ CreateTripView (Sheet)
│   └─ Navigation → TripDetailView
│
├─ BudgetView
│   ├─ Picker (Trip Selection)
│   ├─ ExpenseRowView (Component)
│   └─ AddExpenseView (Sheet)
│
├─ ChatListView
│   ├─ ChatListItemView
│   └─ Navigation → ChatView
│       ├─ ChatBubbleView (Component)
│       └─ Input Field
│
├─ VotingView
│   ├─ Picker (Trip Selection)
│   ├─ PollCardView
│   ├─ VoteOptionView
│   └─ CreatePollView (Sheet)
│
├─ FriendsView
│   ├─ FriendRowView (Component)
│   ├─ PendingRequestRowView (Component)
│   └─ AddFriendView (Sheet)
│
└─ ProfileView
    ├─ StatCardView (Component)
    ├─ SettingRowView (Component)
    └─ EditProfileView (Sheet)
```

### View Patterns

#### List View Pattern
```swift
struct ListExampleView: View {
    @Query var items: [Item]
    @State private var filter = "all"
    
    var filteredItems: [Item] {
        items.filter { /* filter logic */ }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        RowView(item: item)
                    }
                }
            }
        }
    }
}
```

#### Form View Pattern
```swift
struct FormExampleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var field1 = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Field", text: $field1)
                }
                Section {
                    Button("Save") {
                        save()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func save() {
        let item = MyModel(field1)
        modelContext.insert(item)
        try? modelContext.save()
        dismiss()
    }
}
```

#### Detail View Pattern
```swift
struct DetailView: View {
    let item: Item
    @State private var selectedTab = "Tab1"
    
    var body: some View {
        VStack {
            // Tab Navigation
            HStack {
                ForEach(["Tab1", "Tab2"], id: \.self) { tab in
                    Text(tab)
                        .onTapGesture {
                            selectedTab = tab
                        }
                }
            }
            
            // Content
            if selectedTab == "Tab1" {
                Tab1Content()
            } else {
                Tab2Content()
            }
        }
    }
}
```

---

## Data Flow

### Example: Trip erstellen

```
User
  ↓
CreateTripView (Form Input)
  ↓
Button: "Create Trip"
  ↓
Klick: createTrip() Function
  ↓
Trip instance erstellen
  ↓
modelContext.insert(trip)
  ↓
try? modelContext.save()
  ↓
dismiss() View
  ↓
TripsListView: @Query aktualisiert sich automatisch
  ↓
UI zeigt neue Trip-Card
```

### Example: Nachricht senden

```
User tippt Nachricht
  ↓
TextField: $messageText
  ↓
Button: sendMessage() antippen
  ↓
ChatMessage instance erstellen
  ↓
modelContext.insert(message)
  ↓
messageText = "" (clear input)
  ↓
ChatView: @Query aktualisiert sich
  ↓
ChatBubble erscheint, Auto-Scroll
```

---

## State Management

### @State (View-Level)
```swift
@State private var showSheet = false
@State private var selectedFilter = "all"
```

### @Environment (Dependency Injection)
```swift
@Environment(\.modelContext) private var modelContext
@Environment(\.dismiss) var dismiss
```

### @Query (Data Binding)
```swift
@Query var trips: [Trip]  // Auto-update bei changes
```

### @Observable (ViewModel)
```swift
@Observable
class TripsViewModel {
    var trips: [Trip] { ... }
}
```

---

## SwiftData Integration

### ModelContainer Setup (TravelhubApp)
```swift
@main
struct TravelhubApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Trip.self,
            Friend.self,
            ChatMessage.self,
            BudgetExpense.self,
            Poll.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
```

### CRUD Operations

#### Create (Insert)
```swift
let newTrip = Trip(title: "Paris", startDate: Date(), endDate: Date())
modelContext.insert(newTrip)
try? modelContext.save()
```

#### Read (Query)
```swift
@Query(sort: \.startDate) var trips: [Trip]
```

#### Update (Modify)
```swift
trip.title = "New Title"
try? modelContext.save()
```

#### Delete
```swift
modelContext.delete(trip)
try? modelContext.save()
```

---

## Performance Optimizations

### 1. Lazy Loading
```swift
LazyVStack {
    ForEach(largeList) { item in
        ItemRow(item: item)
    }
}
```

### 2. @ObservationIgnored
```swift
@Observable
class ViewModel {
    @ObservationIgnored
    @Query var items: [Item]  // Doesn't trigger re-render on changes
}
```

### 3. Computed Properties
```swift
var filteredItems: [Item] {
    items.filter { $0.status == "active" }
}
```

### 4. Minimal Re-renders
```swift
@State private var selectedTab = 0  // Only updates content, not header
```

---

## Error Handling

### ModelContext Errors
```swift
do {
    try modelContext.save()
} catch {
    print("Failed to save: \(error)")
}
```

### Safe Optional Binding
```swift
if let email = userEmail, !email.isEmpty {
    addFriend(email)
}
```

---

## Testing Strategy

### Unit Testing (ViewModels)
```swift
class TripsViewModelTests: XCTestCase {
    func testFilterActiveTrips() {
        let vm = TripsViewModel()
        let active = vm.activeTrips
        XCTAssertTrue(active.allSatisfy { $0.isActive })
    }
}
```

### UI Testing (Views)
```swift
func testCreateTripFlow() {
    app.buttons["addTripButton"].tap()
    app.textFields["titleField"].typeText("Paris")
    app.buttons["createButton"].tap()
    XCTAssertTrue(app.staticTexts["Paris"].exists)
}
```

---

## Skalierbarkeit

### Wenn App wächst:

#### 1. Services Layer hinzufügen
```swift
protocol DataService {
    func fetchTrips() async -> [Trip]
    func saveTrip(_ trip: Trip) async
}

class FirebaseDataService: DataService { ... }
```

#### 2. Dependency Injection
```swift
@Environment(\.dataService) var dataService
```

#### 3. Network Layer
```swift
struct APIManager {
    func fetchTrips() async throws -> [Trip]
}
```

#### 4. State Management erweitern
```swift
@Observable
class AppState {
    var currentUser: User?
    var trips: [Trip] = []
    var isLoading = false
}
```

---

## Best Practices Verwendet

✅ **MVVM Pattern**: Separation of Concerns  
✅ **SwiftUI Reactive**: @Query, @Observable, @State  
✅ **SwiftData**: Local Persistence  
✅ **NavigationStack**: Modern Navigation  
✅ **Sheet/Modal**: For Input Forms  
✅ **Environment**: Dependency Injection  
✅ **Components**: Reusable Views  
✅ **Type Safety**: Strong typing überall  
✅ **Error Handling**: try/catch patterns  
✅ **Async/Await Ready**: Future-proof structure

---

## Zukünftige Architektur-Verbesserungen

- [ ] Services Layer (DataService, NetworkService)
- [ ] Combine Publishers (wenn komplexer State)
- [ ] Async/Await für Network Calls
- [ ] Custom Reducers (Redux Pattern)
- [ ] Dependency Injection Container
- [ ] Logging Framework
- [ ] Analytics Integration
- [ ] Error Recovery Strategies

---

**Architektur Version**: 1.0  
**Pattern**: MVVM + SwiftData  
**Scalability**: Klein bis Mittel  
**Testability**: Hoch (vor allem ViewModels)

