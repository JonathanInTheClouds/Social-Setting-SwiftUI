//
//  AlignedTextField.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/30/22.
//

import SwiftUI

struct AlignedTextField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    var isSecuredText: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Text(label)
                    .foregroundColor(Color.gray)
                Spacer()
            }
            .frame(width: 100, alignment: .center)
            
            
            if isSecuredText {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.sRGB, red: 235/255, green: 235/255, blue: 235/255, opacity: 1))
        .cornerRadius(10)
    }
}

struct AlignedTextField_Previews: PreviewProvider {
    static var previews: some View {
        AlignedTextField(label: "Name", placeholder: "Your fancy name", text: .constant(""))
    }
}
