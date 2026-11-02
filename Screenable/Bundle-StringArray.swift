//
//  Bundle-StringArray.swift
//  Screenable
//
//  Created by Ali Soner Inceoglu on 02.11.26.
//

import Foundation

extension Bundle {
    func loadStringArray(from file: String) -> [String] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        return string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
    }
}
