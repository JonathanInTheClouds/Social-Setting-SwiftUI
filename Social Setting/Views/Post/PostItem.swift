//
//  PostItem.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import SwiftUI

struct PostItem: View {
    
    var header: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 45)
            
            VStack(alignment: .leading) {
                Text("Bernice Miles")
                HStack(spacing: 4) {
                    Text("@adrewww_")
                    Text("•")
                    Text("2h ago")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
            }
            .foregroundColor(.secondary)

        }
    }
    
    var text: some View {
        HStack {
            Text("Come on @craig_love what are you talking about? Isn't it a joke?")
            Spacer()
        }
    }
    
    var media: some View {
        ZStack {
            Rectangle()
                .fill(Color.tertiary)
            
            VStack() {
                Spacer()
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 45)
                    
                    VStack(alignment: .leading) {
                        Text("Bernice Miles")
                            .foregroundColor(.gray)
                        HStack(spacing: 4) {
                            Text("I just won a million in the lottery! ...")
                        }
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.90))
            }
        }
        .cornerRadius(15)
        .frame(height: 200)
    }
    
    var actionButtons: some View {
        HStack {
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "heart")
                    Text("112")
                }
            }
            
            Spacer()
                .frame(maxWidth: 40)
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "text.bubble")
                    Text("16")
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left")
                    Text("24")
                }
            }

        }
        .padding(.horizontal, 10)
        .foregroundColor(.secondary)
    }
    
    var body: some View {
        VStack {
            header
            
            text
            
            media
            
            actionButtons
                .padding(.vertical)
        }
    }
}

struct PostItem_Previews: PreviewProvider {
    static var previews: some View {
        PostItem()
            .padding(.horizontal, 21)
    }
}
