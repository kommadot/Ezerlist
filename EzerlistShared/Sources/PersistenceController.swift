import CoreData

public struct PersistenceController {
    public static let shared = PersistenceController()
    
    public let container: NSPersistentContainer
    
    public init() {
        // Core Data 모델 파일을 명시적으로 로드
        guard let modelURL = Bundle(for: TodoItemMO.self).url(forResource: "Ezerlist", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Core Data model not found")
        }
        
        container = NSPersistentContainer(name: "Ezerlist", managedObjectModel: model)
        
        // App Group container URL 설정
        if let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupId)?
            .appendingPathComponent("Ezerlist.sqlite") {
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
    
    public static var preview: PersistenceController = {
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
