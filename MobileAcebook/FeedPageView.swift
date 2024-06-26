//
//  FeedPageView.swift
//  MobileAcebook
//
//  Created by Patrick Skipworth on 17/04/2024.
//

import SwiftUI
struct FeedPageView: View {

    @ObservedObject var postStore = PostStore()
    @State var message = ""
    @State var token = ""
    @State private var selectedImage: UIImage?

    //    Initialise userDefaults var to get / write token as userDefaults key
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            VStack {
                Text("View all posts")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 30))
                    .padding(.bottom, 20)
            }
            .background(Color(red: 253/255, green: 210/255, blue: 184/255))
            VStack {
                Section() {
                    HStack {
                        HStack {
                            TextField("Enter message", text:$message, axis: .vertical)

                        }
                        .padding(.horizontal, 15)
                        .frame(minHeight: 50)
                        
                        Spacer()
                        
                        Button("Post"){
                            guard !message.isEmpty else { return }
                            token = userDefaults.object(forKey: "token") as! String
                            postStore.createPost(token: token, message: message) { newToken, newMessage in
                                print("Post created successfully!")
                                userDefaults.set(newToken, forKey: "token")
                                token = newToken
                            }
                            message = ""
                        }
                        .padding(.trailing, 15)
                    }
                }
                .padding(.horizontal, 15)
                
                List($postStore.posts, id: \._id) { post in
                    HStack {
                        VStack {

                            //Currently returning placeholder image 
                            // Async doesn't work - url is currently pulling a jpeg file name, need to save images either locally in assets or in e.g. Cloudinary
                            AsyncImage(url: URL(string: post.createdBy.profilePicture.wrappedValue)) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(Circle())
                                                } placeholder: {
                                                    Image("profile")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(Circle())
                                                }
                            
                            Text("\(post.createdBy.username.wrappedValue)")
                                .font(.system(size: 10))
                        }
                        
                        VStack {
                            Text("Message: \(post.message.wrappedValue)")
                                .multilineTextAlignment(.leading)
                                .frame(width: 200)
                                .font(.system(size: 14))
                            
                            Text("\(formattedDate(from: post.createdAt.wrappedValue))")
                                .multilineTextAlignment(.leading)
                                .frame(width: 200)
                                .font(.system(size: 10))
                            Button(action: {
                                postStore.likePost(token: token, postId: post._id.wrappedValue) {newLikes in
                                    print("Successully liked!")
                                    token = userDefaults.object(forKey: "token") as! String
                                    postStore.getPosts(token:token) { fetchedPosts, token, error in
                                        print("Successully updated!")
                                    }
                                }
                            }) {
                                HStack {
                                    Image("like")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("\(post.likes.count)")
                                }
                            }
                            
                        }
                    }
                }
                .onAppear {
                    token = userDefaults.object(forKey: "token") as! String
                    postStore.getPosts(token:token) { fetchedPosts, token, error in
                        if let error = error {
                            print("Error fetching posts:", error)
                        } else {
                            print("Received posts in FeedPageView:", fetchedPosts)
                        }
                    }
                }
            }
          }
        }
    }
    
    struct FeedPageView_Previews: PreviewProvider {
        static var previews: some View {
            FeedPageView()
        }
    }
