//
//  ToggleView.swift
//  SwiftUIDemo
//
//  Created by Kevin Huang on 5/26/23.
//

import SwiftUI

struct ToggleView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .frame(width: 136, height: 64)
                .foregroundColor(Color(uiColor: .white))
            Toggle(isOn: .constant(true))
            {
                Text("on")
            }
            .padding()
        }
        .frame(width: 136, height: 64)
        .shadow(radius: 0.5)
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
    }
}
