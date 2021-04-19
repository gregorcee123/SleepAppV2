//
//  SwiftUIView.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 13/04/2021.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
            
            VStack{
            Text("Analyse your sleep using only the microphone")
                .foregroundColor(Color(UIColor(red: 0.03, green: 0.24, blue: 0.44, alpha: 1.00)))
                .font(.system(size: 26))
                .fontWeight(.heavy)
                .padding(.leading, 0)
                //.offset(x:-12)
                .multilineTextAlignment(.center)

                Spacer()
            Text("When you're ready to sleep press the snooze button and we'll be waiting for you in the morning.")
                .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                .font(.system(size: 16.0))
                .fontWeight(.light)
                .transition(AnyTransition.opacity.animation(.easeInOut(duration:0.5)))


                .multilineTextAlignment(.center)
            }.padding()


            .cornerRadius(10)
            .frame(width: 350, height: 165, alignment: .center)
            .background(Color(UIColor(red: 0.12, green: 0.56, blue: 1.00, alpha: 1.00)))
            /*.overlay(Rectangle().frame(width: 5, height: 150, alignment: .bottomLeading).foregroundColor(Color(UIColor(red: 0.03, green: 0.24, blue: 0.44, alpha: 1.00)
)), alignment: .bottomLeading)
            .offset(x:10)*/
            
    }
        
    }


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
