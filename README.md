# flutter_ble

본 프로젝트는 Flutter를 이용하여 BLE(Bluetooth Low Energy) 통신 기능을 구현한 예제입니다.
BLE 디바이스 검색, 연결, 데이터 송수신 등의 기능을 포함하고 있습니다.

## Getting Started

### 사전 준비 사항

- Flutter SDK 설치 (FVM 사용 권장)

### 설치 및 실행

```bash
https://github.com/Younggun-Kim/flutter-ble.git
cd flutter-ble
fvm use
flutter pub get
flutter run
```

## flutter_blue_plus 패키지

* Bluetooth Low Energy(BLE) 통신을 위한 패키지입니다.(Bluetooth Classic ❌)
* BLE 중 BLE Central Role 기능만 지원합니다.
* iOS는 `CoreLocation` 필수

## 참고

- [FVM 설치](https://fvm.app/documentation/getting-started#quick-start)