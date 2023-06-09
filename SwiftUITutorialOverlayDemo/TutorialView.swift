//
//  TutorialView.swift
//  SwiftUIDemo
//
//  Created by Kevin Huang on 5/19/23.
//

import SwiftUI

struct TutorialView: View {
    @Binding var tutorialElements: [TutorialElement]
    var onExitButtonClick: () -> Void = {}
    @State private var currentTutorialElementIndex: Int = 0
    @State private var tutorialTextMinY: CGFloat = 0
    @State private var tutorialTextHeight: CGFloat = 0
    
    private var currentTutorialElement: TutorialElement? {
        (tutorialElements.count > 0 && currentTutorialElementIndex <= tutorialElements.count - 1) ? tutorialElements[currentTutorialElementIndex] : nil
    }
            
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TutorialOverlayShapeView(geometry: geometry,
                                    elementFrame: currentTutorialElement?.elementFrame ?? .zero,
                                    isCircle: currentTutorialElement?.isCircle ?? false,
                                    cornerRadius: currentTutorialElement?.cornerRadius ?? 0)
                VStack {
                    HStack {
                        // Tutorial text - needs to be positioned under or above the element window depending on where the element is
                        VStack(alignment: .leading) {
                            Text(currentTutorialElement?.headerText ?? "")
                                .font(.title2)
                                .padding(.bottom, 5)
                            Text(currentTutorialElement?.bodyText ?? "")
                        }
                        .padding([.leading, .trailing], 25)
                        .anchorPreference(key: ViewHeightPreferenceKey.self, value: .bounds, transform: {
                            geometry[$0].height
                        })
                        .offset(x: 0, y: tutorialTextMinY)
                        .onPreferenceChange(ViewHeightPreferenceKey.self) { tutorialTextHeight in
                            self.tutorialTextHeight = tutorialTextHeight
                            updateTutorialTextMinY(screenHeight: geometry.size.height)
                        }
                        .onChange(of: currentTutorialElementIndex) { _ in
                            updateTutorialTextMinY(screenHeight: geometry.size.height)
                        }
                        .onAppear {
                            // We need this because even though the @Binding tutorialElements causes this view to redraw
                            // when tutorialElements change (when they update their own frame data in the onPreferenceChange there),
                            // the .onPreferenceChange here does not get called if the tutorial text did not change
                            // so it won't update the positioning of the text (the position will remain at the top of the screen as it was
                            // when the element rect was initially .zero). Calling the update method here updates the text positioning whenever
                            // the view is redrawn.
                            updateTutorialTextMinY(screenHeight: geometry.size.height)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    Spacer()
                    getNavigationView()
                }
                .padding([.leading, .trailing], 25)
                .padding(.bottom, 40)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func getNavigationView() -> some View {
        HStack {
            Button(action: {
                currentTutorialElement?.onPrevButtonPress()
                returnToPrevElement()
            }, label: {
                Text("Prev").bold()
            })
            Spacer()
            Button(action: {
                onExitButtonClick()
            }, label: {
                Text("Exit").bold()
            })
            Spacer()
            Button(action: {
                currentTutorialElement?.onNextButtonPress()
                advanceToNextElement()
            }, label: {
                Text("Next").bold()
            })
        }
    }
    
    private func updateTutorialTextMinY(screenHeight: CGFloat) {
        guard let elementRect = currentTutorialElement?.elementFrame else { return }
        let verticalPadding: CGFloat = 40
        // Check if there is more room at the top or bottom of the element and assign y accordingly
        if (elementRect.midY < screenHeight / 2) { // more room at the bottom
            tutorialTextMinY = elementRect.maxY + verticalPadding
        } else {
            tutorialTextMinY = elementRect.minY - tutorialTextHeight - verticalPadding
        }
    }
    
    private func advanceToNextElement() {
        currentTutorialElementIndex = currentTutorialElementIndex < tutorialElements.count - 1 ? currentTutorialElementIndex + 1 : currentTutorialElementIndex
    }
    
    private func returnToPrevElement() {
        currentTutorialElementIndex = currentTutorialElementIndex > 0 ? currentTutorialElementIndex - 1 : currentTutorialElementIndex
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(tutorialElements: .constant([
            TutorialElement(tutorialTag: .button1,
                            elementFrame: CGRect(x: 50, y: 150, width: 200, height: 100),
                            cornerRadius: 10,
                            headerText: "Test Header text Test",
                            bodyText: "Test body text"),
            TutorialElement(tutorialTag: .rectangle,
                            elementFrame: CGRect(x: 80, y: 450, width: 200, height: 300),
                            cornerRadius: 10,
                            headerText: "Test header text",
                            bodyText: "Test body text jdlfkjkefj lkej lkejk elkfj ekjf ej  kejf je kj ")
        ]))
    }
}

extension View {
    func enableForTutorial(tag: TutorialTag) -> some View {
        self.transformAnchorPreference(key: TutorialBoundsPreferenceKey.self, value: .bounds) { value, anchor in return value.append(TutorialBoundsPreferenceValue(tutorialTag: tag, anchor: anchor))
        }
    }
}
