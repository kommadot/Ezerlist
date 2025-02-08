import Foundation

public enum Constants {
    public static let appGroupId = "group.com.izerlist.shared"
    public static let widgetKind = "IzerlistWidget"
    
    public enum UserDefaultsKeys {
        public static let todos = "todos"
    }
    
    public enum Widget {
        public static let maxDisplayItems = 4
        public static let refreshInterval: TimeInterval = 30 * 60 // 30 minutes
    }
}
