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
    
    // 1. We accept an array of NSItemProviders that might contain file URLs
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        // 2. We only care about the first item; bail out if we can't read that
        guard let item = providers.first else { return false }
       
        // 3. Load the first item
        item.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { data, error in
            // 4. if it succeeds, convert the data into a URL
            if let data = data as? Data {
                guard let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                // 5. Load the URL into a Data object
                let loadedImage = try? Data(contentsOf: url)
                // 6. Copy the data into our userImage property
                Task { @MainActor in
                    document.userImage = loadedImage
                }
            }
        }
        
        // 7. Signal that the drop was received successfully
        return true
    }
}

#Preview {
    let document = ScreenableDocument()
    document.caption = "Hei there"
    
    return ContentView(document: document)
}
