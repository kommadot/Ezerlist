# Izerlist

간단하고 빠른 iOS To-Do List 위젯 앱

## 주요 기능

- 빠른 할 일 추가 및 체크 기능
- 생성 일자별 및 완료 일자별 필터링
- iOS 위젯 지원
- 앱과 위젯 간 데이터 공유

## 개발 환경

- iOS 14.0+
- Swift 5.0+
- SwiftUI
- WidgetKit

## 프로젝트 구조

```
IzerlistApp/
├── Sources/
│   ├── Models/         # 데이터 모델
│   ├── Views/          # UI 컴포넌트
│   ├── ViewModels/     # 뷰 모델
│   ├── Services/       # 데이터 관리 서비스
│   └── Utils/          # 유틸리티 함수
├── Resources/
│   ├── Assets.xcassets/ # 이미지 및 색상 리소스
│   └── Fonts/          # 커스텀 폰트
└── Info.plist

IzerlistWidget/
├── Sources/            # 위젯 관련 소스
├── Resources/          # 위젯 리소스
└── Info.plist
```

## 설치 방법

1. Xcode에서 프로젝트를 엽니다.
2. App Group 설정을 합니다.
3. 실행할 기기 또는 시뮬레이터를 선택합니다.
4. Run 버튼을 클릭하여 앱을 실행합니다.

## 라이선스

MIT License
