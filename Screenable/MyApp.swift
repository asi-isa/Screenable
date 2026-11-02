import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
       DocumentGroup { document in
           ContentView(document: document)
       } makeDocument: { _, _ in
           ScreenableDocument()
       }
   }
}
