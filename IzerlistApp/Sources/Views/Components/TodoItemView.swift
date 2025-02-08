import SwiftUI
import IzerlistShared

struct TodoItemView: View {
    let item: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Text(item.title)
                .strikethrough(item.isCompleted)
            Spacer()
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
        }
        .padding(.vertical, Theme.spacing)
    }
}
