//
//  MusicAuthViewModel.swift
//  LyraArchive
//
//  이 파일은 Apple Music 권한 상태를 문자열로 변환하여 UI에 표시하기 위해 작성됨.
//
//  Created by 하동훈 on 19/9/2025.
//

import MusicKit
import Combine

@MainActor
final class MusicAuthViewModel: ObservableObject {
    @Published var info: String = ""
    
    func explain(status: MusicAuthorization.Status) {
        switch status {
        case .authorized:       info = "권한 허용됨. 사용자 라이브러리 접근/재생 가능."
        case .denied:           info = "권한 거부됨. 설정 > Lyra에서 권한을 허용해야합니다."
        case .restricted:       info = "권한 제한됨. 장치 정책으로 차단되었습니다."
        case .notDetermined:    info = "아직 묻지 않음. 권한 요청을 눌러보세요."
        @unknown default:       info = "알 수 없는 상태입니다."
        }
    }
}
