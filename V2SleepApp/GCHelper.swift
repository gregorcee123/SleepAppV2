//
//  GCHelper.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 11/04/2021.
//

import SwiftUI
import AudioKit
import AVFoundation
import AudioKitUI


// helper function to convert time stored in seconds into a readable version
func timerCalc(totalT: Int) -> String{
    let realSecs = (totalT/4)
    let hours = (Int(realSecs))/3600
    let minutes = ((Int(realSecs))/60) % 60
    let seconds = (Int(realSecs))%60
    let timeInString = ("\(hours)hr, \(minutes)min, \(seconds)s")
    return timeInString
}


// helper function to convert old uiview into new swiftui in order
// to use for main view
struct PlotView: UIViewRepresentable{
    var waveform: NodeOutputPlot
    
    
    func makeUIView(context: Context) -> some UIView {

        waveform.plotType = .rolling
        waveform.shouldFill = true
        waveform.shouldMirror = true
        waveform.color = UIColor.white
        waveform.gain = 10
        waveform.start()
        return waveform
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //update the view
    }
}


// extends view to allow for a screenshot to be taken
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
