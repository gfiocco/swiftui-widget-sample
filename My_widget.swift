import WidgetKit
import SwiftUI

struct EmojiEntry: TimelineEntry {
    let date : Date
    let emoji : Emoji
}

struct EmojiProvider: TimelineProvider {

    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.your-identifier.widget-sample"))
    var emojiData: Data = Data()
    
    // generic visual representation with no specific content
    func placeholder(in context: Context) -> EmojiEntry {
        return EmojiEntry(date: Date(), emoji: Emoji(icon: "😶", name: "N/A", description: "N/A"))
    }

    // provides preview of the widget when adding it via the widget gallery
    func getSnapshot(in context: Context, completion: @escaping (EmojiEntry) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }
        let entry = EmojiEntry(date: Date(), emoji: emoji)
        completion(entry)
    }

    // provides an array of timeline entries of when to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<EmojiEntry>) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }
        let entry = EmojiEntry(date: Date(), emoji: emoji)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct EmojiWidgetView : View {
    let entry: EmojiProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    @ViewBuilder
    var body: some View {
        switch family {
            case .systemSmall:
                EmojiView(emoji: entry.emoji)
            case .systemMedium:
                HStack {
                    EmojiView(emoji: entry.emoji)
                    Text(entry.emoji.name)
                        .font(.largeTitle)
                }
            default:
                VStack (spacing: 30) {
                    HStack (spacing: 30) {
                        EmojiView(emoji: entry.emoji)
                        Text(entry.emoji.name)
                            .font(.largeTitle)
                    }
                    Text(entry.emoji.description)
                        .font(.title2)
                        .padding()
                }
        }
    }
}

@main
struct EmojiWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "EmojiWidget",
            provider: EmojiProvider()
        ) { entry in
            EmojiWidgetView(entry: entry)
        }
        .configurationDisplayName("Emoji")
        .description("Shows user Emoji status")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
