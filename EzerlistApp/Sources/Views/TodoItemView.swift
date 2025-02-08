import SwiftUI
import EzerlistShared

struct TodoItemView: View {
    let item: TodoItem
    let toggleAction: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isCompleting = false
    @State private var isChecked = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                isChecked = true
                isCompleting = true
            }
            
            // 체크 애니메이션이 끝난 후 토글 액션 실행
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                toggleAction()
            }
        }) {
            HStack(spacing: 16) {
                // 체크마크 아이콘
                ZStack {
                    Circle()
                        .stroke(isChecked || item.isCompleted ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isChecked || item.isCompleted {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .animation(.spring(response: 0.2), value: isChecked)
                
                // 할 일 내용
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title ?? "")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isChecked || item.isCompleted ? .gray : .primary)
                        .strikethrough(isChecked || item.isCompleted)
                        .lineLimit(1)
                    
                    Text(item.createdDate.formatted(.relative(presentation: .named)))
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(CardButtonStyle())
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(isCompleting ? 0.2 : 0))
        )
        .onAppear {
            // 이미 완료된 항목은 체크 표시
            isChecked = item.isCompleted
        }
    }
}

// 카드 버튼 스타일
struct CardButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

// 미리보기용 확장
extension TodoItemView {
    static var preview: some View {
        let context = PersistenceController.preview.container.viewContext
        let item = TodoItemMO()
        item.id = UUID()
        item.title = "샘플 할 일"
        item.createdDate = Date()
        item.isCompleted = false
        
        return TodoItemView(item: item.todoItem) {}
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
