import WidgetKit
import SwiftUI

struct WeatherEntry: TimelineEntry {
    let date: Date
    let weatherType: String
}

struct WeatherProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), weatherType: "sunny")
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(date: Date(), weatherType: getSavedWeatherType())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let entry = WeatherEntry(date: Date(), weatherType: getSavedWeatherType())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    // ✅ UserDefaults에서 저장된 날씨 타입 불러오기
    private func getSavedWeatherType() -> String {
        guard let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaWidget") else {
            print("❌ App Group 설정 오류 (위젯)")
            return "unknown"
        }
        
        // 🚩 ✅ 디버깅용 코드 추가 (위젯에서 확인)
        if let savedData = defaults.string(forKey: "CurrentWeatherType") {
            print("📦 저장된 데이터(위젯): \(savedData)")
            return savedData
        } else {
            print("❌ 데이터 없음 (위젯)")
            return "unknown"
        }
    }


}

struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry

    var body: some View {
        VStack {
            Text("🌦️ 현재 날씨")
            Text(entry.weatherType.capitalized)
                .font(.largeTitle)
        }
        .padding()
        .background(
            Group {
                if #available(iOS 17.0, *) {
                    Color.clear.containerBackground(for: .widget) {
                        Color.clear  // ✅ iOS 17용 배경 처리
                    }
                } else {
                    Color.white  // ✅ iOS 16 이하에서는 단순한 배경 적용
                }
            }
        )
    }
}



struct umbrellaIssueWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("날씨 위젯")
        .description("현재 날씨를 표시합니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
