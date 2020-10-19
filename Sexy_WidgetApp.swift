import WidgetKit
import SwiftUI

struct ContentView: View {
    
    // Not included in Kilo Loco tutorial and used here to facilitate debugging
    @State private var emojiLast : Emoji = Emoji(icon: "😶", name: "N/A", description: "N/A")
    
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.your-identifier.widget-sample"))
    var emojiData: Data = Data()

    let emojis = [
        Emoji(icon: "😀", name: "Happy", description: "The user is happy"),
        Emoji(icon: "😍", name: "Love", description: "The user is in love"),
        Emoji(icon: "🙁", name: "Unhappy", description: "The user is unhappy")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Last stored: \(emojiLast.icon)")
                .font(.largeTitle)
            ForEach (emojis) { emoji in
                EmojiView (emoji: emoji)
                    .onTapGesture(count: 1, perform: {
                        save(emoji)
                    })
            }
        }
    }
    
    func save(_ emoji: Emoji) {
        print("Stored: \(emoji.name)")
        emojiLast = emoji
        guard let emojiData = try? JSONEncoder().encode(emoji) else {return}
        self.emojiData = emojiData
        // Requesting a Reload of Your Widget’s Timeline
        WidgetCenter.shared.reloadAllTimelines()
        // Accordingly to the Apple Developer documentation, WidgetCenter.shared.reloadTimelines(ofKind: "EmojiWidget")
        // should also work, but it does not

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
