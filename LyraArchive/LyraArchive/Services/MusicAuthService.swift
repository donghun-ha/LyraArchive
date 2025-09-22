//
//  MusicAuthService.swift
//  LyraArchive
//
//  이 파일은 Apple Music 권한 상태를 관리하고, 사용자에게 권한을 요청하는 기능을 담당합니다.
//  SwiftUI 뷰에서 직접 MusicKit 권한 로직을 다루지 않고,
//  별도의 서비스 계층으로 분리하여 코드의 가독성과 재사용성을 높이기 위해 작성되었습니다.
//
//  Created by 하동훈 on 19/9/2025.
//

import MusicKit
import Combine

@MainActor
final class MusicAuthService: ObservableObject {
    @Published var status: MusicAuthorization.Status = .notDetermined
    
    init() {
        status = MusicAuthorization.currentStatus
    }
    
    func request() async {
        let s = await MusicAuthorization.request()
        await MainActor.run { self.status = s }
    }
    
    var isAuthorized: Bool { status == .authorized }
}

