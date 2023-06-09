//
//  TutorialBoundsPreference.swift
//  SwiftUIDemo
//
//  Created by Kevin Huang on 5/26/23.
//

import SwiftUI

struct TutorialBoundsPreferenceKey: PreferenceKey {
    typealias Value = [TutorialBoundsPreferenceValue]
    static var defaultValue: Value = []
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

struct TutorialBoundsPreferenceValue: Equatable {
    var tutorialTag: TutorialTag
    var anchor: Anchor<CGRect>
    static func == (lhs: TutorialBoundsPreferenceValue, rhs: TutorialBoundsPreferenceValue) -> Bool {
        return lhs.tutorialTag == rhs.tutorialTag
    }
}
