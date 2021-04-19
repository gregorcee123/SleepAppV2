//
//  processReadings.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 11/04/2021.
//

import Foundation
import SwiftUI
import AudioKit
import AVFoundation
import AudioKitUI



// class for 10 minute amplitude reading
class AmpIntervalReading{
    
    //value of 10 minute amplitude reading
    var value: Float
    // current time of 10 minute ampplitude reading in seconds
    let time: Int
    
    init(reading: Float, current_time: Int){
        
        value = reading
        time = current_time
    }
    
    // alter reading here if need be
    func processReading(){
        
        if value < 0{
            value = 0
        }else if value > 10{
            print("yes")
            
        }
        
    }
    
}



class readingController{
    
    //dataset to be processed for visualization
    var dataset = [AmpIntervalReading]()
    //baseline value of room, when no one is moving. Automatically set to 0.
    var baseline: Float = 0.000000
    var baselineSet = false
    var DataArray:[Double] = [Double]()
    var totalT: Int = 0
    var writeCount = 0
    //var remMin:Double = 0
    //var cap: Double = 0
    var PercentageREMNREM: [Int] = [0,0]
    
    //var tempData = [13.070255279541016, 5.5613274574279785, 12.131007194519043, 9.228766441345215, 6.965187072753906, 6.695645809173584, 6.900879859924316, 9.326278686523438, 11.45414924621582, 8.447962760925293, 15.68502140045166, 10.368982315063477, 12.002833366394043, 12.953130722045898, 21.978824615478516, 8.133308410644531, 7.506362438201904, 7.486764430999756, 7.918541431427002, 12.443282127380371, 7.068533420562744, 6.73153018951416, 6.496515274047852, 6.017838954925537, 8.560582160949707, 11.753570556640625, 5.788952350616455, 6.2019944190979, 6.940127849578857, 8.313614845275879, 9.756349563598633, 11.0977783203125, 10.37925910949707]
    
    var tempData = [16.504392623901367, 13.121464729309082, 13.006428718566895, 11.715590476989746, 11.735298156738281, 11.83005142211914, 12.058338165283203, 14.39835262298584, 15.221829414367676, 18.686016082763672, 18.104890823364258, 18.259775161743164, 12.990303993225098, 14.056831359863281, 13.928977966308594, 12.274579048156738, 11.257576942443848, 10.261736869812012, 14.452381134033203, 15.535248756408691, 13.644408226013184, 11.243093490600586, 7.661685466766357, 7.424321174621582, 8.004976272583008, 7.5325398445129395, 10.887042045593262, 10.648714065551758, 8.194591522216797, 8.01611328125, 8.261353492736816, 8.25085163116455, 8.918367385864258, 10.960753440856934, 10.416107177734375, 14.08419418334961, 8.55121898651123, 8.29314136505127, 9.775992393493652]
    
    init(){

        
        
    }
    
    
    // write sleep data to file for testing
    func writeDataToFile(){
        

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = paths[0]
        var dataToString = ""
        for reading in DataArray{
            
            dataToString.append(" \(String(reading)),")
        }
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"
        
        var time = timeFormatter.string(from: date)
        
        var stringDate = (dateFormatter.string(from: date))
        stringDate = stringDate.replacingOccurrences(of: "/", with: "-")
        time = time.replacingOccurrences(of: ":", with: "")
        
        let dateAndTime = "\(writeCount)-\(time)-\(stringDate)"
                
                let newUrl = url.appendingPathComponent("\(dateAndTime).txt")

                do {
                    try dataToString.write(to: newUrl, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: newUrl)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
        
        writeCount+=1
        
    }
    
    func addReading(reading: AmpIntervalReading){
        self.dataset.append(reading)
        self.DataArray.append(Double(reading.value))
    }
    
    func setBaseline(baselineStandard: Float){
        
        baseline = baselineStandard
        baselineSet = true
    }
    

    func displayIntervalReadingToOutput(){
        
        for reading in dataset{
            print("The average for \(timerCalc(totalT: reading.time)) is \(reading.value)")
        }
    }
    
    func clearData(){
        
        dataset.removeAll()
        DataArray.removeAll()
    }
    
    func makeCap(){
        
        // method one of capping the data
        // Using human data analysis
        
        // you spend rougly 20% of the night in REM Sleep, so the average should be around Deep sleep.
        // Any value roughly 1Amp reading above this average likely involved Awakeness and will be capped as we are uninterested in this data.
        //
        let sum = DataArray.reduce(0, +)
        let noOfReadings = Double(DataArray.count)
        
        let averageReading = Double(sum/noOfReadings)
        var readingCounter = 0
        
        for reading in DataArray{
            
            // do somethig to cap data
            if reading > averageReading+4{
                
                self.DataArray[readingCounter] = averageReading+4
            }
            
            readingCounter+=1
        }
        
        
    }
    
    
    // process Data, cap awake value for graph, find rem and nrem seconds
    func processData(){
        
        // check theres enough data first
        if DataArray.count < 2{
           
            print("not enough time")
            
        }else{
        // cap awake values for the sake of the graph being readable to the user
        // you spend rougly 20% of the night in REM Sleep, so the average should be around Deep sleep - NREM stage 2-3
        // Deep sleep will be when your'e quitest without much movement, which is the majority of the night.
        // for the sake of the graph we'll split the data evenly by capping the max at REM + the difference between Deep and REM.
        // Considering most people spend 20-25% in REM sleep a night, the value at 80% of the sorted array will should be REM.
        
        print(DataArray)
        // next we sort the array in order
        let newArray = DataArray.sorted(by: <)
        
        print(newArray)
        // find the value at 80%
        
            
        let remMin = newArray[Int(Double(DataArray.count)*0.8)]
                
                
        //self.remMin = remMin
        print("remMin - \(remMin)")
        
        //find min value, (likely to be deep sleep, base value of graph
        
        let minVal = DataArray.min()
        
        let difference = remMin-minVal!
        
        let cap = remMin + difference
        //self.cap = cap
        var readingCounter = 0
        
        // set rem counter to 0
        // used to find % of overall sleep in seconds is rem
        var remCounter = 0
        var deepCounter = 0
        
        for reading in DataArray{
            
            //do somethig to cap data
            if reading > cap{
                
                self.DataArray[readingCounter] = cap
            }else if reading >= (remMin-1) && reading < (remMin+3){
                remCounter+=1
                
            }else if reading < (remMin-1){
                deepCounter+=1
            }
            
            readingCounter+=1
        }
        
        print("deep: \(deepCounter) + rem: \(remCounter)")
        
        // set rem and nrem sleep values in (seconds*4) as reading is taken every 1/4 second. each counter is 10 minutes so 2400*4*counter
        PercentageREMNREM = [(remCounter*2400),(deepCounter*2400)]
        }
        
    }
    
    // function to return time in rem and nrem
    func getSleepData() -> [Int]{
        
        
        
        
        
        return [2400, 5400]
        
        
    }
    
}


