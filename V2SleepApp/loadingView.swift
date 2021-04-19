//
//  loadingView.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 12/04/2021.
//
/*
import SwiftUI

struct loadingView: View {
    @State var isLoading = false
    @State private var current: Int? = nil
    @State private var animateStrokeStart = true
    @State private var animateStrokeEnd = true
    @State private var isRotating = false
     
    
    
    var body: some View {
        NavigationView {
            ZStack{
            NavigationLink(destination: sleepDisplayView(), tag: 2, selection: $current) {
                EmptyView()
 
            }
                Image("record")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                Circle()
                    .trim(from: animateStrokeStart ? 1/3 : 1/9, to: animateStrokeEnd ? 2/5 : 1)
                    .stroke(lineWidth: 5)
                    .frame(width: 150, height: 150)
                    .foregroundColor(Color(red:0.0, green:0.588, blue:1.0))
                    .rotationEffect(.degrees(isRotating ? 360 : 0))
                    .onAppear(){
                        
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                            {
                            self.isRotating.toggle()
                            
                        }
                        
                        withAnimation(Animation.linear(duration: 1).delay(0.5).repeatForever(autoreverses: true))
                            {
                            
                            self.animateStrokeStart.toggle()
                        }
                        
                        
                        
                        withAnimation(Animation.linear(duration: 1).delay(0.5).repeatForever(autoreverses: true))
                            {
                            
                            self.animateStrokeEnd.toggle()
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
            }.onAppear(){
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.current = 2
                 }
            }
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
        
    
        
        
        

}
    
}

struct intermittentView : View{
    
    @State private var current: Int? = nil
    
    var body: some View{
        
        NavigationView{
            ZStack{
            Text("")
            
            NavigationLink(destination: sleepDisplayView(), tag: 3, selection: $current) {
                EmptyView()
 
            }
            
            
        
        }.onAppear(){
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.current = 3
             }
        }
        
        
    }
    
}

struct loadingView_Previews: PreviewProvider {
    static var previews: some View {
        loadingView()
    }
}

*/
