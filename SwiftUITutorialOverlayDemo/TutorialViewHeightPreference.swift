//
//  TutorialViewHeightPreference.swift
//  SwiftUIDemo
//
//  Created by Kevin Huang on 5/26/23.
//

import SwiftUI

struct ViewHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
