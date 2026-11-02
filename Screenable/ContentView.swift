import SwiftUI

struct ContentView: View {
    @Bindable var document: ScreenableDocument

    var body: some View {
        TextEditor(text: $document.caption)
            .padding()
    }
}
