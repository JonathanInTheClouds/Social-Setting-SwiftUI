//
//  PostItem.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import SwiftUI

struct PostItem: View {
    
    var post: PostResponse
    
    var header: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 45)
            
            VStack(alignment: .leading) {
                Text(post.user.username)
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
        .padding(.bottom, 10)
    }
    
    var text: some View {
        HStack {
            Text(post.body)
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
            
//            media
            
            actionButtons
                .padding(.vertical)
        }
    }
}

struct PostItem_Previews: PreviewProvider {
    static var previews: some View {
        PostItem(post: .init(id: "1487f41b-a136-4a39-b5b3-87cc7866efeb", title: "Why is Java so Good", body: "And when did it start becoming widely used?", voteCount: 0, commentCount: 0, user: .init(email: "jon@mail.com", username: "DarkKnight", creationDate: .now)))
            .padding(.horizontal, 21)
    }
}
