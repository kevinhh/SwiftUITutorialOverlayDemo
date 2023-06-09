//
//  TutorialOverlayShapeView.swift
//  SwiftUIDemo
//
//  Created by Kevin Huang on 5/26/23.
//

import SwiftUI

struct TutorialOverlayShapeView: View {
    var geometry: GeometryProxy
    var elementFrame: CGRect
    var isCircle: Bool = false
    var cornerRadius: CGFloat
    var allowInteractionThroughOverlay = true
    let overlayColor = Color(red: 0.847, green: 0.796, blue: 0.898).opacity(0.9)
    let windowPadding: CGFloat = 15 // The window is the "hole" that lets the element through. This is a padding around that hole.
    var windowCornerRadius: CGFloat {
        // There is a cornerRadius for the element, it looks odd if the window (with padding) has the same corner radius, so add a little more.
        return cornerRadius > 0 ? cornerRadius + windowPadding / 2 : 0
    }
    
    var body: some View {
        Path { path in
            path.addRect(geometry.frame(in: .global))
            let frameWithPadding = CGRect(x: elementFrame.minX - windowPadding, y: elementFrame.minY - windowPadding, width: elementFrame.width + 2*windowPadding, height: elementFrame.height + 2*windowPadding)
            
            if isCircle {
                path.addEllipse(in: frameWithPadding)
            } else {
                path.addRoundedRect(in: frameWithPadding, cornerSize: CGSize(width: windowCornerRadius, height: windowCornerRadius))
            }
        }
        .fill(overlayColor, style: FillStyle(eoFill: true))
        
        if (!allowInteractionThroughOverlay) {
            Path { path in
                path.addRect(geometry.frame(in: .global))
            }
            .fill(Color.purple.opacity(0.001))
        }
    }
}

struct TutorialOverlayShapeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            TutorialOverlayShapeView(geometry: geometry, elementFrame: CGRect(x: 50, y: 150, width: 200, height: 100), cornerRadius: 10)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
