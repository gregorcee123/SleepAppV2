//
//  tuner.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 09/04/2021.
//

import SwiftUI
import AudioKit
import AVFoundation
import AudioKitUI


struct amplitudeDataV2{
    
    var amplitude: Float = 0.0
    //var amplitudeArray: [Float] = [0.0]

}

class amplitudeDataConductorV2: ObservableObject{
    
    let engine = AudioEngine()
    var mic: AudioEngine.InputNode
    var tappableNode1: Fader
    var tappableNode2: Fader
    var tappableNode3: Fader
    var tracker: AmplitudeTap!
    var silence: Fader
    var timer: Timer?
    
    @Published var data = amplitudeDataV2()

    
    func update(_amp: AUValue){
        
        data.amplitude = _amp
        //data.amplitudeArray.append(_amp)
        
    }
    
    init(){
        
        guard let input = engine.input else {
            fatalError()
        }
        mic = input
        tappableNode1 = Fader(mic)
        tappableNode2 = Fader(tappableNode1, gain: 10)
        tappableNode3 = Fader(tappableNode2)
        tracker = AmplitudeTap(mic)
        silence = Fader(tappableNode3, gain: 0)
        engine.output = silence
        
    }
    
    func updateAmp(isTracking: Bool){
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
                print("the amplitude is \(self.tracker.amplitude*100000.0)")
                self.update(_amp: self.tracker.amplitude*100000)
        }
    }
    
    func start(){
        
        do {
            try engine.start()
            tracker.start()
            updateAmp(isTracking: true)
        } catch let err {
            Log(err)
            print("this crashes here")
        }
    }
    
    func stop(){
        tracker.stop()
        engine.stop()
        timer?.invalidate()
        //print(data.amplitudeArray)
    }
     
}



struct amplitudeviewV2: View {
    @ObservedObject var conductor = amplitudeDataConductorV2()
    @State private var showDevices: Bool = false
    @State var isPlaying = false

    
    var body: some View {
        ZStack{
            Color(.white)
            .edgesIgnoringSafeArea(.all)
        VStack {
            VStack {
                Text("Hello world")
                    .foregroundColor(.black)
                HStack {
                    Text("Amplitude")
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(conductor.data.amplitude, specifier: "%0.1f")")
                        .foregroundColor(.black)
                    }.padding()
            }
            Button(action: {
                if isPlaying{
                    conductor.stop()
                    isPlaying.toggle()
                }else{
                    conductor.start()
                    isPlaying.toggle()
                }
                }, label: {
                    Text(isPlaying ? "Stop Reocring" : "Start Recording")
                        .foregroundColor(Color.blue)
                })
                Spacer()
            NodeRollingView(conductor.tappableNode2, color: .blue).clipped()
                .frame(width: 300, height: 100, alignment: .center)
                .scaleEffect(x:1, y:2.3)
            Spacer()
                
        }
        }
}
}


struct amplitudeview_previewV2: PreviewProvider {
    
    static var previews: some View {

        amplitudeviewV2()
    }
}


