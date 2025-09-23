//
//  ArchiveList.swift
//  LyraArchive
//
//  아카이브 목록 화면
//  - 추가 버튼 -> 시트로 입력창 표시
//  - 스와이프로 삭제
//
//  Created by 하동훈 on 23/9/2025.
//

import SwiftUI
import CoreData

struct ArchiveListView: View {
    @StateObject private var viewModel: ArchiveListViewModel
    @State private var showingAdd = false
    @State private var renamingArchive: Archive?
    @State private var tempTitle: String = ""

    init(context: NSManagedObjectContext) {
        // 화면에서 Store를 생성하여 ViewModel 주입
        _viewModel = StateObject(wrappedValue: ArchiveListViewModel(store: .init(context: context)))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.archives, id: \.objectID) { archive in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(archive.title ?? "제목 없음")
                                .font(.headline)
                            if let mood = archive.mood, !mood.isEmpty {
                                Text("기분: \(mood)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if let note = archive.note, !note.isEmpty {
                                Text(note)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        Spacer()
                        Button {
                            renamingArchive = archive
                            tempTitle = archive.title ?? ""
                        } label: {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("Lyra Archive")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddArchiveView(viewModel: viewModel)
            }
            .alert("알림", isPresented: .constant(viewModel.alertMessage != nil)) {
                Button("확인") { viewModel.alertMessage = nil }
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
            .sheet(item: $renamingArchive) { archive in
                RenameSheet(title: $tempTitle) {
                    viewModel.rename(archive, to: tempTitle)
                }
            }
            .onAppear { viewModel.load() }
        }
    }
}

private struct RenameSheet: View {
    @Binding var title: String
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("새 제목", text: $title)
            }
            .navigationTitle("제목 수정")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("닫기") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        onSave()
                        dismiss()
                    }.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let pc = PersistenceController.preview
    return ArchiveListView(context: pc.container.viewContext)
        .environment(\.managedObjectContext, pc.container.viewContext)
}
