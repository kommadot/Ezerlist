import Foundation
import CoreData
import WidgetKit

public class TodoStore: ObservableObject {
    public static let shared = TodoStore()
    
    @Published public private(set) var items: [TodoItem] = []
    private let viewContext: NSManagedObjectContext
    
    public init(persistenceController: PersistenceController = .shared) {
        self.viewContext = persistenceController.container.viewContext
        loadItems()
    }
    
    private func loadItems() {
        let request = NSFetchRequest<TodoItemMO>(entityName: "TodoItem")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoItemMO.createdDate, ascending: false)]
        request.predicate = NSPredicate(format: "isCompleted == NO")
        
        do {
            let managedObjects = try viewContext.fetch(request)
            items = managedObjects.map { $0.todoItem }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    private func save() {
        do {
            try viewContext.save()
            loadItems()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    public func addItem(_ title: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: viewContext) else {
            fatalError("Failed to find entity description for TodoItem")
        }
        let newItem = TodoItemMO(entity: entity, insertInto: viewContext)
        newItem.id = UUID()
        newItem.title = title
        newItem.createdDate = Date()
        newItem.isCompleted = false
        
        save()
    }
    
    public func toggleItem(_ item: TodoItem) {
        let request = NSFetchRequest<TodoItemMO>(entityName: "TodoItem")
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            let results = try viewContext.fetch(request)
            if let existingItem = results.first {
                existingItem.isCompleted.toggle()
                existingItem.completedDate = existingItem.isCompleted ? Date() : nil
                save()
            }
        } catch {
            print("Failed to toggle item: \(error)")
        }
    }
    
    public func itemsByDate(_ date: Date) -> [TodoItem] {
        let calendar = Calendar.current
        let request = NSFetchRequest<TodoItemMO>(entityName: "TodoItem")
        request.predicate = NSPredicate(format: "createdDate >= %@ AND createdDate < %@ AND isCompleted == NO",
                                      calendar.startOfDay(for: date) as NSDate,
                                      calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: date)!) as NSDate)
        
        do {
            let results = try viewContext.fetch(request)
            return results.map { $0.todoItem }
        } catch {
            print("Failed to fetch items by date: \(error)")
            return []
        }
    }
    
    public func completedItemsByDate(_ date: Date) -> [TodoItem] {
        let calendar = Calendar.current
        let request = NSFetchRequest<TodoItemMO>(entityName: "TodoItem")
        request.predicate = NSPredicate(format: "completedDate >= %@ AND completedDate < %@ AND isCompleted == YES",
                                      calendar.startOfDay(for: date) as NSDate,
                                      calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: date)!) as NSDate)
        
        do {
            let results = try viewContext.fetch(request)
            return results.map { $0.todoItem }
        } catch {
            print("Failed to fetch completed items by date: \(error)")
            return []
        }
    }
    
    // MARK: - Widget Support
    
    public func fetchTodayItems() -> [TodoItem] {
        itemsByDate(Date())
    }
}
