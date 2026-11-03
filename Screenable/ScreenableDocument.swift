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
    var backgroundImage = ""
    var userImage: Data?
    var captionColor = Color.black
    var backgroundColorTop = Color.clear
    var backgroundColorBottom = Color.clear
    var dropShadowLocation = 0
    var dropShadowStrength = 1

    struct Snapshot: Codable, Sendable {
        var caption: String
        var font: String
        var fontSize: Int
        var backgroundImage: String
        var userImage: Data?
        var captionColor: Color
        var backgroundColorTop: Color
        var backgroundColorBottom: Color
        var dropShadowLocation: Int
        var dropShadowStrength: Int
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
        font = snapshot.font
        fontSize = snapshot.fontSize
        backgroundImage = snapshot.backgroundImage
        userImage = snapshot.userImage
        captionColor = snapshot.captionColor
        backgroundColorTop = snapshot.backgroundColorTop
        backgroundColorBottom = snapshot.backgroundColorBottom
        dropShadowLocation = snapshot.dropShadowLocation
        dropShadowStrength = snapshot.dropShadowStrength
    }

    // MARK: - Writing

    @MainActor
    func snapshot(
        contentType: UTType
    ) async throws -> sending Snapshot {
        Snapshot(
            caption: caption,
            font: font,
            fontSize: fontSize,
            backgroundImage: backgroundImage,
            userImage: userImage,
            captionColor: captionColor,
            backgroundColorTop: backgroundColorTop,
            backgroundColorBottom: backgroundColorBottom,
            dropShadowLocation: dropShadowLocation,
            dropShadowStrength: dropShadowStrength
        )
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
