//
//  ArchiveListViewModel.swift
//  LyraArchive
//
//  목록 화면의 상태/로직 담당
//  - 데이터 로딩/추가/삭제/수정
//  - 입력 폼 상태 관리
//
//  Created by 하동훈 on 23/9/2025.

import Foundation
import CoreData

@MainActor
final class ArchiveListViewModel: ObservableObject {
    @Published var archives: [Archive] = []

    // 입력 폼 상태
    @Published var newTitle: String = ""
    @Published var newMood: String = ""
    @Published var newNote: String = ""

    // 에러/알림 메시지
    @Published var alertMessage: String?

    private let store: ArchiveStore

    init(store: ArchiveStore) {
        self.store = store
    }

    // 초기 로딩
    func load() {
        do {
            archives = try store.fetchArchives()
        } catch {
            alertMessage = "목록을 불러오지 못했습니다: \(error.localizedDescription)"
        }
    }

    // 새 항목 추가
    func add() {
        guard !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "제목을 입력해주세요."
            return
        }
        do {
            try store.addArchive(title: newTitle, mood: newMood.isEmpty ? nil : newMood, note: newNote.isEmpty ? nil : newNote)
            clearForm()
            load()
        } catch {
            alertMessage = "저장 실패: \(error.localizedDescription)"
        }
    }

    // 삭제
    func delete(at offsets: IndexSet) {
        do {
            try store.deleteArchives(at: offsets, in: archives)
            load()
        } catch {
            alertMessage = "삭제 실패: \(error.localizedDescription)"
        }
    }

    // 수정 (샘플: 제목만 바꾸는 예시)
    func rename(_ archive: Archive, to title: String) {
        do {
            try store.updateArchive(archive, title: title, mood: archive.mood, note: archive.note)
            load()
        } catch {
            alertMessage = "수정 실패: \(error.localizedDescription)"
        }
    }

    // 폼 리셋
    func clearForm() {
        newTitle = ""
        newMood = ""
        newNote = ""
    }
}

