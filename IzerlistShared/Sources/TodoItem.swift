import Foundation

public struct TodoItem: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let createdDate: Date
    public var completedDate: Date?
    public var isCompleted: Bool
    
    public init(id: UUID = UUID(), title: String, createdDate: Date = Date(), completedDate: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.createdDate = createdDate
        self.completedDate = completedDate
        self.isCompleted = isCompleted
    }
}
