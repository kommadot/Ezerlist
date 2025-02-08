import SwiftUI
import EzerlistShared

struct CompletedTasksView: View {
    @StateObject private var store = TodoStore.shared
    @State private var selectedDate = Date()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 날짜 선택기
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        )
                        .padding(.horizontal, 16)
                    
                    // 완료된 항목 목록
                    LazyVStack(spacing: 0) {
                        ForEach(store.completedItemsByDate(selectedDate)) { item in
                            TodoItemView(item: item) {
                                store.toggleItem(item)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Completed")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
