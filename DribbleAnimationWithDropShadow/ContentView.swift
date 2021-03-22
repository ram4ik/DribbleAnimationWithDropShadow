//
//  ContentView.swift
//  DribbleAnimationWithDropShadow
//
//  Created by Ramill Ibragimov on 22.03.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Dribble Animation")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State private var rotateBall = false
    @State private var showPopUp = false
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack {
            Toggle(isOn: $rotateBall, label: {
                Text("Rotate Ball")
            })
            .padding()
            .padding(.vertical)
            
            Button(action: {
                withAnimation(.spring()) {
                    showPopUp.toggle()
                }
            }, label: {
                Text("Show PopUp")
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(scheme == .dark ? Color.black : Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.primary.opacity(0.07), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.primary.opacity(0.07), radius: 5, x: -5, y: -5)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            ZStack {
                if showPopUp {
                    Color.primary.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showPopUp.toggle()
                            }
                        }
                    DribbleAnimatedView(showPopup: $showPopUp, rotateBall: $rotateBall)
                    //.offset(y: showPopUp ? 0 : UIScreen.main.bounds.height)
                    
                }
            }
        )
    }
}

struct DribbleAnimatedView: View {
    @Environment(\.colorScheme) var scheme
    
    @Binding var showPopup: Bool
    @Binding var rotateBall: Bool
    
    @State var animateBall = false
    @State var animateRotation = false
    
    var body: some View {
        ZStack {
            (scheme == .dark ? Color.black : Color.white)
                .frame(width: 150, height: 150)
                .cornerRadius(14)
                .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 5, y: 5)
                .shadow(color: Color.primary.opacity(0.1), radius: 5, x: -5, y: -5)
            
            Circle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 40)
                .rotation3DEffect(
                    .init(degrees: 60),
                    axis: (x: 1, y: 0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 1.0
                )
                .offset(y: 35)
                .opacity(animateBall ? 1 : 0)
            
            Image(systemName: "swift")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .rotationEffect(.init(degrees: rotateBall && animateRotation ? 360 : 0))
                .offset(y: animateBall ? 10 : -25)
        }
        .onAppear() {
            doAnimation()
        }
    }
    
    func doAnimation() {
        withAnimation(Animation.easeOut(duration: 0.4).repeatForever(autoreverses: true)) {
            animateBall.toggle()
        }
        
        withAnimation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false)) {
            animateRotation.toggle()
        }
    }
}
