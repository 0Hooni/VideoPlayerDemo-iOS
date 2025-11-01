# 🎬 iOS Video Player Demo

iOS 동영상 기술을 학습하기 위한 경량 비디오 플레이어 데모 앱입니다.

## ✨ 주요 기능

### 핵심 기능

- **로컬 비디오 재생**: 앱 번들에 포함된 mp4 파일 재생
- **HLS 스트리밍**: HTTP Live Streaming 프로토콜 지원
- **재생 컨트롤**: 재생/일시정지, 구간 탐색(seek), 시간 표시
- **Picture-in-Picture**: 다른 앱 사용 중에도 작은 창으로 영상 시청
- **백그라운드 재생**: 앱이 백그라운드로 이동해도 오디오 계속 재생
- **Lock Screen 컨트롤**: 잠금 화면에서 재생 제어 및 정보 표시

### 추가 기능 (선택)

- 재생 속도 조절 (0.5x ~ 2x)
- 볼륨 컨트롤
- 네트워크 오류 핸들링

## 🛠️ 기술 스택

- **언어**: Swift
- **UI 프레임워크**: SwiftUI / UIKit
- **주요 프레임워크**:
  - `AVFoundation`: 동영상 재생 핵심 엔진
  - `AVKit`: Picture-in-Picture 기능
  - `MediaPlayer`: Lock Screen 미디어 컨트롤

## 📋 요구사항

- iOS 17.0+
- Xcode 26.0+
- Swift 6.0+

## 🚀 설치 및 실행

1. 저장소 클론

```bash
git clone [repository-url]
cd VideoPlayerDemo
```

2. Xcode에서 프로젝트 열기

```bash
open VideoPlayerDemo.xcodeproj
```

3. 시뮬레이터 또는 실제 기기에서 실행
   - PIP 기능은 실제 기기에서만 동작합니다

## 📱 화면 구성

### 1. 비디오 목록 화면

- 번들에 포함된 샘플 영상 리스트
- HLS URL 입력 버튼

### 2. 플레이어 화면

- 전체화면 비디오 뷰
- 커스텀 재생 컨트롤
- PIP 모드 전환 버튼

### 3. HLS URL 입력

- 커스텀 HLS 스트림 URL 입력
- 테스트용 샘플 URL 프리셋

## 🏗️ 프로젝트 구조

```
VideoPlayerDemo/
├── App/
│   ├── VideoPlayerDemoApp.swift
│   └── Info.plist
├── Models/
│   └── Video.swift
├── Views/
│   ├── VideoListView.swift
│   ├── PlayerView.swift
│   └── URLInputView.swift
├── ViewModels/
│   └── PlayerViewModel.swift
├── Managers/
│   ├── VideoPlayerManager.swift
│   └── BackgroundAudioManager.swift
└── Resources/
    └── Videos/
        ├── short_video.mp4
        ├── medium_video.mp4
        └── sample_urls.json
```

## 🎯 학습 포인트

이 프로젝트를 통해 다음을 학습할 수 있습니다:

1. **AVPlayer 기본**

   - AVPlayer 및 AVPlayerLayer 사용법
   - 재생 상태 관찰 (KVO)
   - Time observation 및 seek 구현

2. **스트리밍**

   - HLS(HTTP Live Streaming) 프로토콜
   - 원격 미디어 로딩 및 버퍼링

3. **Picture-in-Picture**

   - AVPictureInPictureController 설정
   - PIP 델리게이트 처리

4. **백그라운드 재생**

   - AVAudioSession 설정
   - Background Modes 구성
   - Now Playing Info Center 연동

5. **Lock Screen 컨트롤**
   - MPNowPlayingInfoCenter 사용
   - Remote Command Center 이벤트 처리

## 🔧 주요 설정

### Info.plist

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### Capabilities

- Background Modes > Audio, AirPlay, and Picture in Picture

## 📝 테스트 HLS URL

앱에는 다음 테스트 URL이 포함되어 있습니다:

- Apple 공식 샘플 스트림
- 기타 공개 테스트 스트림

## 🐛 알려진 이슈

- PIP 모드는 iOS 시뮬레이터에서 지원되지 않음
- 일부 HLS 스트림은 CORS 정책으로 재생 불가할 수 있음

## 📚 참고 자료

- [AVFoundation Programming Guide](https://developer.apple.com/documentation/avfoundation)
- [HLS Authoring Specification](https://developer.apple.com/documentation/http_live_streaming)
- [Picture in Picture Documentation](https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_standard_player)

## 📄 라이센스

MIT License

## 👨‍💻 개발자

학습 및 데모 목적으로 제작된 프로젝트입니다.
