import SwiftUI
import EzerlistShared

struct MainTasksView: View {
    @StateObject private var store = TodoStore.shared
    @State private var newItemTitle = ""
    @FocusState private var isInputFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private func addItem() {
        if !newItemTitle.isEmpty {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                store.addItem(newItemTitle)
                newItemTitle = ""
                isInputFocused = true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if store.items.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 48))
                                .foregroundStyle(.tertiary)
                            Text("모든 할 일을 완료했어요!")
                                .font(.system(size: 17))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        ForEach(store.items) { item in
                            TodoItemView(item: item) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    store.toggleItem(item)
                                }
                            }
                            .transition(
                                .asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .opacity.combined(with: .scale(scale: 0.9))
                                )
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                // 나중에 동기화 기능 추가 가능
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Divider()
                        .opacity(0.5)
                    HStack(spacing: 16) {
                        TextField("할 일 추가하기...", text: $newItemTitle)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            )
                            .focused($isInputFocused)
                            .onSubmit(addItem)
                        
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.indigo)
                        }
                        .disabled(newItemTitle.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle("할 일")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
