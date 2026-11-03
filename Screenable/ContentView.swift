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
                    
                    HStack {
                        Picker("Select a caption font", selection: $document.font) {
                            ForEach(fonts, id: \.self, content: Text.init)
                        }
                        
                        ColorPicker("Caption color", selection: $document.captionColor)
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
                
                VStack(alignment: .leading) {
                    Text("Background color")
                        .bold()
                    
                    Text("If set to non-transparent, this will be drawn over the background image.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 20) {
                        ColorPicker("Start:", selection: $document.backgroundColorTop)
                        ColorPicker("End:", selection: $document.backgroundColorBottom)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Drop shadow")
                        .bold()
                    
                    Picker("Drop shadow location", selection: $document.dropShadowLocation) {
                        Text("None").tag(0)
                        Text("Text").tag(1)
                        Text("Device").tag(2)
                        Text("Both").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    
                    Stepper("Shadow radius: \(document.dropShadowStrength)pt", value: $document.dropShadowStrength, in: 1...20)
                }
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
