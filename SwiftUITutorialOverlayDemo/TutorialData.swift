//
//  TutorialElement.swift
//  SwiftUIDemo
//
//  Created by Kevin Huang on 5/26/23.
//

import Foundation

enum TutorialTag: CaseIterable {
    case button1
    case rectangle
    case text1
    case hstack
    case circle
    case toggle
}

struct TutorialElement: Equatable {
    var tutorialTag: TutorialTag
    var elementFrame: CGRect = .zero
    var cornerRadius: CGFloat = 0
    var isCircle: Bool = false
    var headerText: String
    var bodyText: String
    var onNextButtonPress: () -> Void = {}
    var onPrevButtonPress: () -> Void = {}
        
    static func == (lhs: TutorialElement, rhs: TutorialElement) -> Bool {
        return lhs.tutorialTag == rhs.tutorialTag
    }
}


