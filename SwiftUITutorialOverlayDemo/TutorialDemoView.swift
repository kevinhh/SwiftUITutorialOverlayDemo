//
//  ContentView.swift
//
//  Created by Kevin Huang on 5/11/23.
//

import SwiftUI

struct TutorialDemoView: View {
    @State private var tutorialElements: [TutorialElement] = getTutorialElements()
    @State private var shouldShowTutorial = true
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(spacing: 70) {
                    ButtonsView()
                        .enableForTutorial(tag: .hstack)
                    
                    Text("Text 1")
                        .padding()
                        .background(.brown)
                        .enableForTutorial(tag: .text1)
                    Circle()
                        .fill(.blue)
                        .onTapGesture {
                            shouldShowTutorial = true
                        }
                        .frame(width: 44)
                        .enableForTutorial(tag: .circle)
                    ToggleView()
                        .enableForTutorial(tag: .toggle)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onPreferenceChange(TutorialBoundsPreferenceKey.self) { preferenceValues in
                    tutorialElements = getUpdatedTutorialElements(tutorialElements: tutorialElements,
                                                                  preferenceValues: preferenceValues,
                                                                  geometry: geometry)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            if shouldShowTutorial {
                TutorialView(tutorialElements: $tutorialElements, onExitButtonClick: {
                    shouldShowTutorial = false
                })
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
    }
    
    private struct ButtonsView: View {
        var body: some View {
            HStack(spacing: 50) {
                Button(action: {}, label: { Text("Button 1") })
                    .padding()
                    .background(.yellow)
                    .cornerRadius(10)
                    .enableForTutorial(tag: .button1)
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]),
                                         startPoint: .top,
                                         endPoint: .bottom))
                    .frame(width: 80, height: 220)
                    .enableForTutorial(tag: .rectangle)
            }
        }
    }
    
    private func getUpdatedTutorialElements(tutorialElements: [TutorialElement], preferenceValues: [TutorialBoundsPreferenceValue], geometry: GeometryProxy) -> [TutorialElement] {
        var newTutorialElements = tutorialElements
        for preferenceValue in preferenceValues {
            if let index = tutorialElements.firstIndex(where: { $0.tutorialTag == preferenceValue.tutorialTag }) {
                var tutorialElement = tutorialElements[index]
                tutorialElement.elementFrame = geometry[preferenceValue.anchor]
                newTutorialElements[index] = tutorialElement // This changes the array and triggers TutorialView to update
            }
        }
        return newTutorialElements
    }
    
    // Initialize the list of TutorialElements, set some data. This is the order that the elements will appear in
    // Please refer to TutorialElement for all the fields
    private static func getTutorialElements() -> [TutorialElement] {
        [
            TutorialElement(tutorialTag: .button1,
                            cornerRadius: 10,
                            headerText: "Button 1 header description",
                            bodyText: "Button 1 body description"),

            TutorialElement(tutorialTag: .rectangle,
                            cornerRadius: 10,
                            headerText: "Rectangle header description",
                            bodyText: "Rectangle body description"),

            TutorialElement(tutorialTag: .text1,
                            headerText: "Text 1 header description",
                            bodyText: "Text 1 body description"),

            TutorialElement(tutorialTag: .hstack,
                            headerText: "HStack header description",
                            bodyText: "HStack body description"),

            TutorialElement(tutorialTag: .circle,
                            isCircle: true,
                            headerText: "Circle header description",
                            bodyText: "Circle body description"),

            TutorialElement(tutorialTag: .toggle,
                            cornerRadius: 18,
                            headerText: "Toggle header description",
                            bodyText: "Toggle body description")
        ]
    }
}

struct TutorialDemoView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialDemoView()
    }
}
