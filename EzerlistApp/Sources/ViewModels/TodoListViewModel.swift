import Foundation
import Combine
import EzerlistShared

class TodoListViewModel: ObservableObject {
    @Published private(set) var todayItems: [TodoItem] = []
    @Published private(set) var completedItems: [TodoItem] = []
    
    private let store = TodoStore.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        store.$items
            .sink { [weak self] items in
                self?.updateLists()
            }
            .store(in: &cancellables)
    }
    
    func updateLists() {
        let selectedDate = Date()
        todayItems = store.itemsByDate(selectedDate)
        completedItems = store.completedItemsByDate(selectedDate)
    }
    
    func addItem(_ title: String) {
        store.addItem(title)
    }
    
    func toggleItem(_ item: TodoItem) {
        store.toggleItem(item)
    }
}
