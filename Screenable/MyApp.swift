import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
       DocumentGroup { document in
           ContentView(document: document)
       } makeDocument: { _, _ in
           ScreenableDocument()
       }
       .commands {
           CommandGroup(after: .saveItem) {
               Button("Export") {
                   NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
               }
               .keyboardShortcut("e")
           }
           CommandMenu("Export") {
               Menu("Options") {
                   Button("Ignore Background") {
                       // action code
                   }
                   Button("Also Render Thumbnail") {
                       // action code
                   }
               }
               
               Button("Export as PNG") {
                   NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
               }
               .keyboardShortcut("t")
           }
       }
   }
}
