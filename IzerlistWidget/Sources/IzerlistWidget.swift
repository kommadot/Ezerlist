import WidgetKit
import SwiftUI
import CoreData
import IzerlistShared

struct Provider: TimelineProvider {
    let store = TodoStore.shared
    
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date(), items: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> ()) {
        let entry = TodoEntry(date: Date(), items: store.fetchTodayItems())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: Int(Constants.Widget.refreshInterval/60), to: currentDate)!
        let entry = TodoEntry(date: currentDate, items: store.fetchTodayItems())
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

struct TodoEntry: TimelineEntry {
    let date: Date
    let items: [TodoItem]
}

struct IzerlistWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Today's Tasks")
                    .font(.headline)
                Spacer()
                Text("\(entry.items.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(entry.items.prefix(family == .systemSmall ? 3 : Constants.Widget.maxDisplayItems)) { item in
                HStack {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(item.isCompleted ? .green : .gray)
                    Text(item.title)
                        .lineLimit(1)
                }
                .font(.subheadline)
            }
            
            if entry.items.isEmpty {
                Text("No tasks for today")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

@main
struct IzerlistWidget: Widget {
    let kind: String = Constants.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            IzerlistWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Izerlist")
        .description("Show your today's tasks")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
