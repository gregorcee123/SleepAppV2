//
//  rollingview.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 11/04/2021.
//
/*
import AudioKit
import Accelerate
import AVFoundation
import SwiftUI
import Metal
import MetalKit

public class RollingViewData {
    let bufferSampleCount = 128
    var history = [Float](repeating: 0.0, count: 1024)
    var framesToRMS = 128

    func calculate(_ nodeTap: RawDataTap) -> [Float] {
        var framesToTransform = [Float]()

        let signal = nodeTap.data

        for j in 0 ..< bufferSampleCount / framesToRMS {
            for i in 0 ..< framesToRMS {
                framesToTransform.append(signal[i + j * framesToRMS])
            }

            var rms: Float = 0.0
            vDSP_rmsqv(signal, 1, &rms, vDSP_Length(framesToRMS))
            history.reverse()
            _ = history.popLast()
            history.reverse()
            history.append(rms)
        }
        return history

    }
}

func trythis(){
    
    let roll = NodeRollingViewEd()
    
}

public struct NodeRollingViewEd {

    
    var nodeTap: RawDataTap
    var metalFragment: FragmentBuilderE
    var rollingData = RollingViewData()

    public init(_ node: Node, color: Color = .gray, bufferSize: Int = 1024) {

        metalFragment = FragmentBuilderE(foregroundColor: color.cg, isCentered: false, isFilled: false)
        nodeTap = RawDataTap(node, bufferSize: UInt32(bufferSize))
    }

    var plot: FloatPlot {
        nodeTap.start()

        return FloatPlot(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024), fragment: metalFragment.stringValue) {
            rollingData.calculate(nodeTap)
        }
    }
    
    

}

public class FragmentBuilderE {
        var foregroundColor: CGColor = Color.gray.cg
        var backgroundColor: CGColor = Color.clear.cg
        var isCentered: Bool = true
        var isFilled: Bool = true
        var isFFT: Bool = false

        init(foregroundColor: CGColor = Color.white.cg,
             isCentered: Bool = true,
             isFilled: Bool = true,
             isFFT: Bool = false)
        {
            self.foregroundColor = foregroundColor
            self.isCentered = isCentered
            self.isFilled = isFilled
            self.isFFT = isFFT
        }

        var stringValue: String {
            return """
            float sample = waveform.sample(s, \(isFFT ? "(pow(10, in.t.x) - 1.0) / 9.0" : "in.t.x")).x;

            half4 backgroundColor{\(backgroundColor.components![0]), \(backgroundColor.components![1]),\(backgroundColor.components![2]),\(backgroundColor.components![3])};
            half4 foregroundColor{\(foregroundColor.components![0]), \(foregroundColor.components![1]),\(foregroundColor.components![2]),\(foregroundColor.components![3])};

            float y = (-in.t.y + \(isCentered ? 0.5 : 1));
            float d = \(isFilled ? "fmax(fabs(y) - fabs(sample), 0)" : "fabs(y - sample)");
            float alpha = \(isFFT ? "fabs(1/(50 * d))" : "smoothstep(0.01, 0.04, d)");
            return { mix(foregroundColor, backgroundColor, alpha) };
            """
        }
    }
 */
