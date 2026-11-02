//
//  RenderView.swift
//  Screenable
//
//  Created by Ali Soner Inceoglu on 02.11.26.
//

import SwiftUI

struct RenderView: View {
    let document: ScreenableDocument
    
    var body: some View {
        Canvas { context, size in
            // set up
            let fullSizeRect = CGRect(origin: .zero, size: size)
            let fullSizePath = Path(fullSizeRect)
            let phoneSize = CGSize(width: 300, height: 607)
            let imageInsets = CGSize(width: 16, height: 14)
            
            // draw the background image
            context.fill(fullSizePath, with: .color(.white))
            
            // add a gradient
            
            // draw the caption
            var verticalOffset = 0.0
            if document.caption.isEmpty {
                verticalOffset = (size.height - phoneSize.height) / 2
            } else {
                if let resolvedCaption = context.resolveSymbol(id: "Text") {
                    // center the text
                    let textPosition = (size.width - resolvedCaption.size.width) / 2
                    // draw it 20 points from the top
                    context.draw(resolvedCaption, in: CGRect(origin: CGPoint(x: textPosition, y: 20), size: resolvedCaption.size))
                    // use the text height + 20 before the text + 20 after the text for verticalOffset
                    verticalOffset = resolvedCaption.size.height + 40
                }
            }
           
            // draw the phone
        } symbols: {
            // add custom SwiftUI views
            Text(document.caption)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .tag("Text")
        }
        .frame(width: 414, height: 736)
    }
}

#Preview {
    let document = ScreenableDocument()
    document.caption = "Hello, World!"
    
    return RenderView(document: document)
}
