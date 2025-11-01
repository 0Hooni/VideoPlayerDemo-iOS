## 🎬 iOS 동영상 플레이어 데모앱 기획 스펙

### 📱 화면 구성

**1. 메인 화면 (비디오 목록)**

- 번들에 포함된 샘플 영상 2-3개 리스트
- HLS URL 입력 버튼
- 각 항목 탭하면 플레이어 화면으로 이동

**2. 플레이어 화면**

- 전체화면 비디오 뷰
- 커스텀 컨트롤 오버레이
  - 재생/일시정지 버튼
  - 탐색바 (seek bar)
  - 현재 시간 / 전체 시간 표시
  - PIP 전환 버튼
  - 닫기 버튼

**3. HLS URL 입력 다이얼로그**

- URL 입력 필드
- 테스트용 샘플 URL 몇 개 프리셋으로 제공
- 재생 버튼

---

### 🎯 핵심 기능

**필수 기능**

- ✅ 로컬 mp4 파일 재생
- ✅ HLS 스트림 재생
- ✅ 재생/일시정지
- ✅ 구간 탐색 (seek)
- ✅ Picture-in-Picture 모드
- ✅ 백그라운드 오디오 재생 (앱이 백그라운드로 가도 오디오 계속 재생)
- ✅ Lock Screen 컨트롤 (재생/일시정지, 앨범아트)

**선택 기능 (시간 여유 시)**

- 재생 속도 조절 (0.5x, 1x, 1.5x, 2x)
- 볼륨 컨트롤
- 에러 핸들링 UI (네트워크 오류 등)

---

### 🛠️ 기술 스택

**프레임워크**

- AVFoundation (AVPlayer, AVPlayerLayer)
- AVKit (AVPictureInPictureController)
- MediaPlayer (MPNowPlayingInfoCenter - Lock Screen)
- SwiftUI 또는 UIKit (선호하는 걸로)

**주요 클래스**

- `AVPlayer`: 동영상 재생 엔진
- `AVPlayerViewController` 또는 커스텀 플레이어 뷰
- `AVPictureInPictureController`: PIP 기능
- `AVAudioSession`: 백그라운드 재생 설정

**필요한 권한/설정**

- Info.plist: Audio Background Mode
- Capability: Background Modes (Audio)

---

### 📦 번들 리소스

**샘플 영상**

- short_video.mp4 (10-30초, 테스트용)
- medium_video.mp4 (2-5분)
- (선택) long_video.mp4 (10분+)

**HLS 테스트 URL**

- Apple 공식 샘플 스트림
- 다른 공개 테스트 스트림

---

### 📅 개발 단계 (1-2주)

**시작일**

- 2025년 11월 1일 ~

**Week 1**

- Day 1-2: 프로젝트 셋업, 기본 UI 구성
- Day 3-4: AVPlayer 연동, 로컬 재생 구현
- Day 5-7: 재생 컨트롤 UI, HLS 지원

**Week 2**

- Day 1-2: PIP 기능 구현
- Day 3-4: 백그라운드 재생, Lock Screen 컨트롤
- Day 5-7: 테스트, 버그 수정, 폴리싱
