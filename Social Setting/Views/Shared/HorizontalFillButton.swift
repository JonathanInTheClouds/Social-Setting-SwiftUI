//
//  HorizontalFillButton.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/29/22.
//

import SwiftUI

struct HorizontalFillButton<Content: View>: View {
    
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void
    let label: () -> Content
    
    init(
        backgroundColor: Color = Color.gray.opacity(0.20),
        cornerRadius: CGFloat = 10,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
        self.label = label
    }
    
    init(
        backgroundColor: Color = Color.gray.opacity(0.20),
        cornerRadius: CGFloat = 10,
        action: @escaping () -> Void,
        title: String
    ) where Content == Text {
        
        self.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            action: action,
            label: { Text(title) }
        )
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                label()
                Spacer()
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

struct HorizontalFillButton_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalFillButton {
            
        } label: {
            Text("Sign Up")
                .bold()
        }
        .padding()

    }
}
