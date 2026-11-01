//
//  ScreenableDocument.swift
//  Screenable
//
//  Created by Ali Soner Inceoglu on 01.11.26.
//

import SwiftUI
import UniformTypeIdentifiers

struct SreenableDocument: FileDocument, Codable {
    static var readableContentTypes = [UTType(exportedAs: "com.alisonerinceoglu.screenable")]
    
    var caption = ""
    
    init() {}
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self = try JSONDecoder().decode(SreenableDocument.self, from: data)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}
