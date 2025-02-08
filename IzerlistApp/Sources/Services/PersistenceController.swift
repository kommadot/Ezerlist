import CoreData
import IzerlistShared

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Izerlist")
        
        // App Group container URL 설정
        if let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupId)?
            .appendingPathComponent("Izerlist.sqlite") {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        
        // 위젯과 데이터 공유를 위한 설정
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Preview Helper
    
    static var preview: PersistenceController = {
        let controller = PersistenceController()
        let viewContext = controller.container.viewContext
        
        // 미리보기용 샘플 데이터 생성
        let sampleTodo = TodoItemMO(context: viewContext)
        sampleTodo.id = UUID()
        sampleTodo.title = "샘플 할 일"
        sampleTodo.createdDate = Date()
        sampleTodo.isCompleted = false
        
        try? viewContext.save()
        
        return controller
    }()
}
