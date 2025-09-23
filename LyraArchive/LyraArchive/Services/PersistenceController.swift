//
//  PersistenceController.swift
//  LyraArchive
//
//  Core Data 스택을 관리하는 파일.
//  - 앱에서 공용으로 쓸 인스턴스: 'shared'
//  - 미리보기/테스트 용 인스턴스: 'preview'
//
//  Created by 하동훈 on 23/9/2025.
//


import CoreData

enum PersistenceError: Error {
    case saveFailed(underlying: Error)
}

struct PersistenceController {
    // 앱 전역에서 사용하는 실제 컨테이너
    static let shared = PersistenceController()
    
    // SwiftUI Preview, 유닛테스트에서 사용하는 메모리 전용 컨테이너
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // 샘플 데이터 주입 (preview에서마 보임)
        let viewContext = controller.container.viewContext
        for i in 1...3 {
            let item = Archive(context: viewContext)
            item.id = UUID()
            item.title = "샘플 아카이브 \(i)"
            item.mood = ["🙂", "😌", "🥳"].randomElement() ?? "🙂"
            item.note = "프리뷰 더미 노트 \(i)"
        }
        try? viewContext.save()
        return controller
    }()
    
    // NSPersistanceContainer 생성
    let container: NSPersistentContainer
    
    // 기본 이니셜라이저
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LyraArchive") // .xcdatamodeld 이름과 일치
        if inMemory {
            // 미리보기용 : 디스크에 저장하지 않도록 설정
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data 로드 실패: \(error)")
            }
        }
        
        // 충돌 정책 등 기본 옵션
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // 편의 저장 함수
    func save(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw PersistenceError.saveFailed(underlying: error)
            }
        }
    }
}
