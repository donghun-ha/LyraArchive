//
//  ArchiveStore.swift
//  LyraArchive
//
//  Core Data에 대한 CRUD를 담당하는 서비스 계층.
//  ViewModel에서는 이 타입만 호출하여 데이터 접근
//
//  Created by 하동훈 on 23/9/2025.
//

import CoreData

final class ArchiveStore {
    private let context: NSManagedObjectContext
    private let saver: (NSManagedObjectContext) throws -> Void

    init(context: NSManagedObjectContext,
         saver: @escaping (NSManagedObjectContext) throws -> Void = PersistenceController.shared.save) {
        self.context = context
        self.saver = saver
    }

    // MARK: - Create
    func addArchive(title: String, mood: String?, note: String?) throws {
        let item = Archive(context: context)
        item.id = UUID()
        item.title = title
        item.mood = mood
        item.note = note
        try saver(context)
    }

    // MARK: - Read
    func fetchArchives() throws -> [Archive] {
        let request: NSFetchRequest<Archive> = Archive.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return try context.fetch(request)
    }

    // MARK: - Update
    func updateArchive(_ archive: Archive, title: String, mood: String?, note: String?) throws {
        archive.title = title
        archive.mood = mood
        archive.note = note
        try saver(context)
    }

    // MARK: - Delete
    func deleteArchive(_ archive: Archive) throws {
        context.delete(archive)
        try saver(context)
    }

    func deleteArchives(at offsets: IndexSet, in list: [Archive]) throws {
        offsets.map { list[$0] }.forEach(context.delete)
        try saver(context)
    }
}
