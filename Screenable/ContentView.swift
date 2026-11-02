import SwiftUI

struct ContentView: View {
    @Bindable var document: ScreenableDocument
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")

    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Caption")
                        .bold()
                    
                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)
                    
                }
                
            }
            .frame(width: 250)
        }
        .padding()
    }
}

#Preview {
    let document = ScreenableDocument()
    document.caption = "Hei there"
    
    return ContentView(document: document)
}
