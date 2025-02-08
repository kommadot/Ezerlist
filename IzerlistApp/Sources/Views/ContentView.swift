import SwiftUI
import IzerlistShared

struct ContentView: View {
    @StateObject private var store = TodoStore.shared
    @State private var newItemTitle = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                // 날짜 선택기
                DatePicker("Select Date",
                          selection: $selectedDate,
                          displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
                
                // 새 할 일 입력
                HStack {
                    TextField("New todo", text: $newItemTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newItemTitle.isEmpty {
                            store.addItem(newItemTitle)
                            newItemTitle = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                // 할 일 목록
                List {
                    Section(header: Text("Today's Tasks")) {
                        ForEach(store.itemsByDate(selectedDate)) { item in
                            TodoItemView(item: item) {
                                store.toggleItem(item)
                            }
                        }
                    }
                    
                    Section(header: Text("Completed Tasks")) {
                        ForEach(store.completedItemsByDate(selectedDate)) { item in
                            TodoItemView(item: item) {
                                store.toggleItem(item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("izerlist")
        }
    }
}
