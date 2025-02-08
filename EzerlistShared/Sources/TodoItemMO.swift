import CoreData

@objc(TodoItemMO)
public class TodoItemMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var createdDate: Date
    @NSManaged public var completedDate: Date?
    @NSManaged public var isCompleted: Bool
}

extension TodoItemMO {
    // TodoItem 구조체로 변환
    
    public var todoItem: TodoItem {
        TodoItem(
            id: id,
            title: title,
            createdDate: createdDate,
            completedDate: completedDate,
            isCompleted: isCompleted
        )
    }
    
    // 정렬을 위한 기본 정렬 디스크립터
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \TodoItemMO.createdDate, ascending: false)]
    }
    
    // 미완료 항목 fetch request
    public static var incompleteFetchRequest: NSFetchRequest<TodoItemMO> {
        let request = NSFetchRequest<TodoItemMO>(entityName: "TodoItemMO")
        request.predicate = NSPredicate(format: "isCompleted == NO")
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    // 완료 항목 fetch request
    public static var completedFetchRequest: NSFetchRequest<TodoItemMO> {
        let request = NSFetchRequest<TodoItemMO>(entityName: "TodoItemMO")
        request.predicate = NSPredicate(format: "isCompleted == YES")
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}
