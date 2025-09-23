//
//  MusicAuthView.swift
//  LyraArchive
//
//  MusicKit 권한을 확인하기 위한 페이지.
//
//  Created by 하동훈 on 20/9/2025.
//

import SwiftUI
import MusicKit

struct MusicAuthView: View {
    @StateObject private var auth = MusicAuthService()
    @StateObject private var vm   = MusicAuthViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Music 권한: \(String(describing: auth.status).replacingOccurrences(of: "MusicAuthorization.Status.", with: ""))")
                .font(.headline)
            Text(vm.info).foregroundColor(.secondary)

            Button("권한 요청") {
                Task {
                    await auth.request()
                    vm.explain(status: auth.status)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear { vm.explain(status: auth.status) }
    }
}
