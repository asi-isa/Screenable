//
//  ScreenableDocument.swift
//  Screenable
//
//  Created by Ali Soner Inceoglu on 01.11.26.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
final class ScreenableDocument: Document {
    static let readableContentTypes = [
        UTType(exportedAs: "com.alisonerinceoglu.screenable")
    ]

    var caption = ""
    var font = "Helvetica Neue"
    var fontSize = 16

    struct Snapshot: Codable, Sendable {
        var caption: String
        var font: String
        var fontSize: Int
    }

    // MARK: - Reading

    func reader(
        configuration: sending ReadConfiguration
    ) -> sending FileWrapperDocumentReader<Snapshot> {
        FileWrapperDocumentReader(configuration) { file in
            guard let data = file.regularFileContents else {
                throw CocoaError(.fileReadCorruptFile)
            }

            return try JSONDecoder().decode(
                Snapshot.self,
                from: data
            )
        }
    }

    @MainActor
    func apply(
        snapshot: sending Snapshot,
        previous: sending Snapshot?
    ) async throws {
        caption = snapshot.caption
    }

    // MARK: - Writing

    @MainActor
    func snapshot(
        contentType: UTType
    ) async throws -> sending Snapshot {
        Snapshot(caption: caption, font: font, fontSize: fontSize)
    }

    func writer(
        configuration: sending WriteConfiguration
    ) -> sending FileWrapperDocumentWriter<Snapshot> {
        FileWrapperDocumentWriter(configuration) { snapshot, _ in
            let data = try JSONEncoder().encode(snapshot)

            return FileWrapper(
                regularFileWithContents: data
            )
        }
    }
}
