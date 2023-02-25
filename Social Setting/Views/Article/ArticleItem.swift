//
//  ArticleItem.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/27/22.
//

import SwiftUI

struct ArticleItem: View {
    
    var post: PostResponse
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(post.title)
                
                Text(post.body)
                    .foregroundColor(Color("Sec"))
                    .font(.subheadline)
                
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Text("by")
                            .foregroundColor(Color("Sec"))
                            .font(.subheadline)
                        
                        Button {
                            
                        } label: {
                            Text(post.user.username)
                                .foregroundColor(Color("Sec"))
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "arrow.up")
                                Text("2")
                            }
                        }
                        .foregroundColor(Color("Sec"))
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "arrow.down")
                                Text("2")
                            }
                        }
                        .foregroundColor(Color("Sec"))
                    }
                }
            }
            Spacer()
        }
    }
    
    func randomPargraph(pargraph : Int = 40 ) -> String {
        var global = ""
        
        for _ in 0..<(Int.random(in: 2..<pargraph)) {
            
            var x = "";
            for _ in 0..<Int.random(in: 2..<15){
                let string = String(format: "%c", Int.random(in: 97..<123)) as String
                x+=string
            }
            global = global +  " " + x
        }
        
        
        
        return global
    }
}

struct ArticleItem_Previews: PreviewProvider {
    static var previews: some View {
        ArticleItem(post: .init(id: "1487f41b-a136-4a39-b5b3-87cc7866efeb", title: "Why is Java so Good", body: "And when did it start becoming widely used?", voteCount: 0, commentCount: 0, user: .init(email: "jon@mail.com", username: "DarkKnight", creationDate: .now)))
            .padding(.horizontal)
    }
}
