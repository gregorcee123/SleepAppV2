//
//  taptap.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 10/02/2021.
//

import SwiftUI
import AudioKit
import AVFoundation
import AudioKitUI


struct amplitudeData{
    
    var amplitude: Float = 0.0
    //for testing within class
    //var amplitudeArray: [Float] = [0.0]
    
}

class amplitudeDataConductor: ObservableObject{
    
    let engine = AudioEngine()
    var mic: AudioEngine.InputNode
    var tappableNode1: Fader
    var tappableNode2: Fader
    var tappableNode3: Fader
    var tracker: AmplitudeTap!
    var silence: Fader
    var timer: Timer?
    var count = 0
    var totalT = 0
    var avgCount: Float = 0.000000
    var timeInString: String = "0 hours, 0 minutes, 0 seconds"
    let dataController: readingController
    var rollingPlot: NodeOutputPlot
    

    
    @Published var data = amplitudeData()

    //let rollingPlot: NodeOutputPlot
    //let fftPlot: NodeFFTPlot
    
    
    func update(_amp: AUValue, _count: Int){
        

        // add count and totaltimecount
        count = count + 1
        totalT = totalT + 1
        
        // check to see if 10 minutes have passed
        
        if count == _count{
            
            // create new datareading
            let newReading = AmpIntervalReading(reading: (avgCount/Float(_count)), current_time: totalT)
            
            //send datareading to data controller
            dataController.addReading(reading: newReading)
            
            // reset count
            count = 0
            // reset average count
            avgCount = Float(0.000000)
            
            if dataController.baselineSet {
                dataController.baseline = 1.2
            }
            
        }
        /*
        // create a new reading
        let newReading = AmpIntervalReading(reading: _amp, current_time: totalT)
        // pass reading to dataController
        dataController.addReading(reading: newReading)
        

        
        
        if count == 240 {
            print("average amp: \(avgCount/240)")
            data.amplitudeArray.append(_amp)
            count = 0
            avgCount = Float(0.000000)
        }
         */
        
        avgCount = avgCount + Float(_amp)
        
        data.amplitude = _amp
        //data.amplitudeArray.append(_amp)
    }
    
    init(){
        
        guard let input = engine.input else {
            fatalError()
        }
        mic = input
        tappableNode1 = Fader(mic)
        tappableNode2 = Fader(tappableNode1, gain: 0)
        tappableNode3 = Fader(tappableNode2)
        tracker = AmplitudeTap(mic)
        silence = Fader(tappableNode3, gain: 0)
        engine.output = silence
        dataController = readingController()
        rollingPlot = NodeOutputPlot(tappableNode1)
    }
    

    
    func updateAmp(isTracking: Bool){
        
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
                self.update(_amp: self.tracker.amplitude*10000, _count: 2400)
        }
    }
    
    func start(){
        
        //data.amplitudeArray = [0.0]
        do {
            try engine.start()
            tracker.start()
            
            updateAmp(isTracking: true)
        } catch let err {
            Log(err)
        }
    }
    
    func stop(){
        tracker.stop()
        engine.stop()
        timer?.invalidate()
        data.amplitude = 0.0
        dataController.totalT = totalT
        //print(data.amplitudeArray)
        totalT = 0
        count = 0
        //print("Total time: \(timerCalc(totalT: totalT))")
        //dataController.writeDataToFile()
        //dataController.makeCap()
        dataController.writeDataToFile()
        dataController.processData()
        dataController.writeDataToFile()
    }
     
}

struct amplitudeview: View {
    @ObservedObject var conductor = amplitudeDataConductor()
    @State private var showDevices: Bool = false
    @State var isPlaying = false
    @State private var current: Int? = nil
    @State private var theId = 0
    @State private var isWelcome = true
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }

    
    var body: some View {
        NavigationView{
            ZStack{
                Color(UIColor(red: 0.12, green: 0.56, blue: 1.00, alpha: 1.00))
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("logov6")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 290, alignment: .center)
                        /*Text("SLEEP BITCH")
                            .foregroundColor(Color.white)
                            .font(.system(size: 40.0))
                            .fontWeight(.semibold)
                            .padding()*/
                        Spacer()
                        
                        /*HStack {
                            Text("Amplitude")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(conductor.data.amplitude, specifier: "%0.1f")")
                        }.foregroundColor(.white).padding()
                        Spacer()*/
                        ZStack{
                        

                            if (isWelcome){
                                
                                WelcomeView()
                                .frame(width: 350, height: 300, alignment: .center)
                                .background(Color(UIColor(red: 0.12, green: 0.56, blue: 1.00, alpha: 1.00)))
                                
                               
                            }else {
                                
                                PlotView(waveform: conductor.rollingPlot).clipped()
                                    .frame(width: 350, height: 300, alignment: .center)
                            }
                       
                            
                            
                            
                        }
                        /*NodeRollingView(conductor.tappableNode2, color: Color(UIColor(red: 0.84, green: 0.77, blue: 1.00, alpha: 1.00))).clipped()
                         .frame(width: 300, height: 100, alignment: .center)
                         .scaleEffect(x:1, y:2.5) */
                        
                        Spacer()
                        
                        
                        NavigationLink(destination: sleepDisplayView(sleepData: conductor.dataController.DataArray, totalT: conductor.dataController.totalT, remnrem: conductor.dataController.PercentageREMNREM), tag: 1, selection: $current) {
                            EmptyView()
                        }
                        Button(action: {
                            if isPlaying{
                                conductor.stop()
                                isPlaying.toggle()
                                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.current = 1
                                //}
                            }else{
                                conductor.start()
                                isWelcome.toggle()
                                isPlaying.toggle()
                            }
                        }) {
                            Image(isPlaying ? "stopRecord" : "record")
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                        }
                        .padding()
                    }
                    Spacer()
            }.onAppear{
                conductor.dataController.clearData()
                conductor.rollingPlot.redraw()
                isWelcome = true
            }
            
        }
        }
}

struct amplitudeview_preview: PreviewProvider {
    
    
    static var previews: some View {
        amplitudeview()
        
    }
}

