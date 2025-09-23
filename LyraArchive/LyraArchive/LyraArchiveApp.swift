//
//  LyraArchiveApp.swift
//  LyraArchive
//
//  Created by 하동훈 on 17/9/2025.
//

import SwiftUI

@main
struct LyraArchiveApp: App {
    var body: some Scene {
        WindowGroup {
            let ctx = PersistenceController.shared.container.viewContext
            ArchiveListView(context: ctx)
                .environment(\.managedObjectContext, ctx)
        }
    }
}
