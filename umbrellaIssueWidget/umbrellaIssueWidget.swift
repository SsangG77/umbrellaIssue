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
            Image(entry.weatherType.capitalized == "rain" ? "umbrella" : entry.weatherType.capitalized == "cloud" ? "cloud" : entry.weatherType.capitalized == "snow" ? "snow" : "sun")
                .resizable()
                .frame(width: 150, height: 150)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(
            Group {
                if #available(iOS 17.0, *) {
                    Color.clear.containerBackground(for: .widget) {
//                            Color.clear  // ✅ iOS 17용 배경 처리
                        returnColor(weather: entry.weatherType.capitalized)
                        
                    }
                } else {
//                        Color.white  // ✅ iOS 16 이하 배경 처리
                    returnColor(weather: entry.weatherType.capitalized)
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
        .configurationDisplayName("우산이슈? 위젯")
        .description("지금부터 8시간후까지의 날씨를 표시합니다.")
        .supportedFamilies([.systemSmall])
    }
}


struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), weatherType: "rain"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
          
        }
    }
}


extension Color {
    init(hexString: String, opacity: Double = 1.0) {
        let hex: Int = Int(hexString, radix: 16)!
        
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}


func returnColor(weather : String) -> LinearGradient {
    if weather == "rain" {
        return LinearGradient(gradient: Gradient(colors: [Color(hexString: "7793EF"), Color(hexString: "D7D7D7")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    } else if weather == "cloud" || weather == "snow" {
        return LinearGradient(gradient: Gradient(colors: [Color(hexString: "FFFFFF"), Color(hexString: "446389")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    } else {
        return LinearGradient(gradient: Gradient(colors: [Color(hexString: "CCCA8F"), Color(hexString: "B20707")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    
    
}
