//
//  FlippableView.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 13/04/2022.
//

import SwiftUI

struct FlippableView<Front: View, Back: View>: View {
    //MARK: Variables
    @State var backDegree = 90.0
    @State var frontDegree = 0.0
    @Binding var isFaceUp: Bool
    
    let durationAndDelay : CGFloat = 0.3
    
    let frontView: Front
    let backView: Back
    
    //MARK: Flip Card Function
    func flipCard () {
        if isFaceUp {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    //MARK: View Body
    var body: some View {
        ZStack {
            frontView
                .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
                .disabled(!isFaceUp)
            backView
                .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
                .disabled(isFaceUp)
        }.onChange(of: isFaceUp) { newValue in
            print("Changed")
            flipCard()
        }
    }
}

struct FlippableView_Previews: PreviewProvider {
    static var previews: some View {
        FlippableView(isFaceUp: .constant(true), frontView: Text("Front"), backView: Text("Back"))
    }
}
