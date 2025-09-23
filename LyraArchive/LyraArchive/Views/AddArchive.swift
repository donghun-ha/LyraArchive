//
//  AddArchive.swift
//  LyraArchive
//
//  아카이브 생성 입력 화면(시트)
//
//  Created by 하동훈 on 23/9/2025.
//

import SwiftUI

struct AddArchiveView: View {
    @ObservedObject var viewModel: ArchiveListViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("필수") {
                    TextField("제목", text: $viewModel.newTitle)
                }
                Section("선택") {
                    TextField("기분(예: 🙂, 😌…)", text: $viewModel.newMood)
                    TextField("메모", text: $viewModel.newNote, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("새 아카이브")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("닫기") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        viewModel.add()
                        if viewModel.alertMessage == nil { dismiss() }
                    }
                    .disabled(viewModel.newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let pc = PersistenceController.preview
    let vm = ArchiveListViewModel(store: .init(context: pc.container.viewContext))
    vm.load()
    return AddArchiveView(viewModel: vm)
}
