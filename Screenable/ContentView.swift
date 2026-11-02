import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Bindable var document: ScreenableDocument
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")

    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
                .onDrop(of: [UTType.fileURL], isTargeted: nil, perform: handleDrop)
            
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
                
                VStack(alignment: .leading) {
                    Text("Background Image")
                        .bold()
                    
                    Picker("Background Image", selection: $document.backgroundImage) {
                        Text("No background image").tag("")
                        Divider()
                        
                        ForEach(backgrounds, id: \.self, content: Text.init)
                    }
                }
                .labelsHidden()
            }
            .frame(width: 250)
        }
        .padding()
    }
    
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first,
              provider.canLoadObject(ofClass: URL.self)
        else {
            return false
        }

        let _ = provider.loadObject(ofClass: URL.self) { url, error in
            guard let url,
                  url.isFileURL,
                  let imageData = try? Data(contentsOf: url)
            else {
                return
            }

            Task { @MainActor in
                document.userImage = imageData
            }
        }

        return true
    }

}

#Preview {
    let document = ScreenableDocument()
    document.caption = "Hei there"
    
    return ContentView(document: document)
}
