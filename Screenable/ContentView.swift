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
                    
                    Picker("Select a caption font", selection: $document.font) {
                        ForEach(fonts, id: \.self, content: Text.init)
                    }
                    
                    Picker("Size of caption font", selection: $document.fontSize) {
                        ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) { size in
                            Text("\(size)pt")
                        }
                    }
                }
                .labelsHidden()
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
