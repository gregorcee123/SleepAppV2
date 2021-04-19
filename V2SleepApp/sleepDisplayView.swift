//
//  sleepDisplayView.swift
//  V2SleepApp
//
//  Created by Gregor  Cassidy on 12/04/2021.
//

import SwiftUI
import SwiftUICharts


public var randomTestDataForPreview = [0.3,0.443434,0.4343,0.4444,0.44324,0.4444,0.4355,0.54445454,0.44543]






struct sleepDisplayController{
    
    //get current day and current date to use for sleep view
    func getDateAndTime() -> [String]{
            
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date())  - 1]
        let stringDate = (dateFormatter.string(from: date))
        return [stringDate, day]
    }
    
    func getXAxis(timeT: Int) -> [String]{
        
        let seconds = timeT/4
        var yAxis1 = ""
        var yAxis2 = ""
        if seconds >= 7200{
            
            let hours = (Int(seconds))/3600
            yAxis2 = "\(hours)hr"
            if hours % 2 == 0{
                yAxis1 = "\(hours/2)hr"
            }else{
                let doubleHours: Double = Double(hours)
                let stringHours = String(format: "%.1f", doubleHours/2)
                yAxis1 = "\(stringHours)hr"
            }
            
        }else{
            
            let mins = (Int(seconds/60))
            yAxis2 = "\(mins)min"
            yAxis1 = "\(Int(mins/2))min"
        }
        
        
        return ["\(yAxis1)", "\(yAxis2)"]
        
    }
    
}


struct sleepDisplayView: View {
    
    @State private var isLoading = false
    let sleepInfo = sleepDisplayController()
    @State var sleepData: [Double]
    var currentDate: Date = Date()
    var totalT: Int
    var remnrem: [Int]
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack{
            Color(UIColor(red: 0.82, green: 0.92, blue: 1.00, alpha: 1.00))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    
                    HStack{
                        
                        Text("\(sleepInfo.getDateAndTime()[1])")
                            .font(.system(size: 26.0))
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                            .padding(.top, 13)
                        
                        
                //item! in vstack
                Text("\(sleepInfo.getDateAndTime()[0])")
                    .font(.system(size: 15.0))
                    .fontWeight(.light)
                    .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                    .padding(.top, 20)
                    }
                    
                    
                    
                    Button(action: {
                        let image = body.snapshot()

                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        showingAlert = true
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .frame(width: 22, height: 22, alignment: .center)
                            .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                            .padding(.top, 12)
                            .padding(.leading, 12)
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notice"), message: Text("Screenshot saved to camera roll"), dismissButton: .default(Text("Got it!")))
                    }

                }.frame(width:350, alignment: .leading)
                .padding(.top, 40)
                
            HStack{
                
                // vertical stack of labels
                VStack{
                    Text("Awake")
                        .font(.system(size: 12.0))
                        .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                    Spacer()
                    Text("REM")
                        .font(.system(size: 12.0))
                        .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                    Spacer()
                    Text("Deep")
                        .font(.system(size: 12.0))
                        .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                }.frame(width:50,height:240)
                .padding(.trailing, 0)
                .offset(x: -4, y: 4)
            VStack{
                Spacer()
                
        //LineView(data: [0.3,0.4,0.4444,0.43,0.3,0.5,0.4,0.2], title: "Test", legend: "dunno", style: Style.mentoring , valueSpecifier: "Mentoring", legendSpecifier: "")
                LineView(data:sleepData ,title: "", style: Style.sleepStyle, legendSpecifier: "")
                .offset(x: -13, y: -10)
                .frame(width: 280, height:330.0)
                .border(Color(UIColor(red: 0.36, green: 0.64, blue: 0.87, alpha: 1.00)), width: 2)
                .overlay(Rectangle().frame(width: 1, height: 330, alignment: .bottomLeading).foregroundColor(Color(UIColor(red: 0.36, green: 0.64, blue: 0.87, alpha: 1.00))), alignment: .bottomLeading)
                .overlay(Rectangle().frame(width: 260, height: 1, alignment: .leading).foregroundColor(Color(UIColor(red: 0.36, green: 0.64, blue: 0.87, alpha: 1.00))), alignment: .bottom)
            
                HStack{
                    Text("0")
                        .font(.system(size: 12.0))
                        .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                    Spacer()
                    Text("\(sleepInfo.getXAxis(timeT: totalT)[0])")
                        .font(.system(size: 12.0))
                        .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                    Spacer()
                    Text("\(sleepInfo.getXAxis(timeT: totalT)[1])")
                        .font(.system(size: 12.0))
                        .foregroundColor(Color(UIColor(red: 0.04, green: 0.36, blue: 0.61, alpha: 1.00)))
                    
                }.frame(width:240)
                .offset(x: 3, y:-5)
                
                    .padding(10)
               
            }.offset(x: -6)
                
            }.frame(width: 400, height: 400, alignment: .center)
            .padding(.bottom,20)
            .padding(.top, 14)
              
 
                
                VStack{
                    HStack{
                    Text("Total sleep time: ")
                        .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                        .font(.system(size: 16.0))
                        .fontWeight(.semibold)
                        
                    
                    Text("\(timerCalc(totalT: totalT))")
                        .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                        .font(.system(size: 14.0))
                        .fontWeight(.none)
                        
                        Spacer()
                        

                    }.padding(.top,6)
                    
                 
                    
                    HStack{
                    Text("Estimated REM: ")
                        .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                        .font(.system(size: 16.0))
                        .fontWeight(.semibold)
                        
                        
                    Text("\(timerCalc(totalT: remnrem[0]))")
                        .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                        .font(.system(size: 14.0))
                        .fontWeight(.none)
                        
                        Spacer()
                        

                    }.padding(.top,1)
                    
                    
                 
                    
                    HStack{
                    Text("Estimated NREM: ")
                        .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                        .font(.system(size: 16.0))
                        .fontWeight(.semibold)
                        
                        
                    Text("\(timerCalc(totalT: remnrem[1]))")
                        .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                        .font(.system(size: 14.0))
                        .fontWeight(.none)
                        
                        Spacer()
                        

                    }.padding(.top,1)
                    
                    Spacer()
                    
                }.frame(width: 350, height: 120, alignment: .leading)
                Spacer()
                
                Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Exit")
                                    .frame(width: 95, height: 32, alignment: .center)
                                    .border(LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 0.40, green: 0.71, blue: 1.00, alpha: 1.00)), Color(UIColor(red: 0.27, green: 0.09, blue: 0.71, alpha: 1.00)), Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00))]), startPoint: .leading, endPoint: .trailing), width: 2)
                                    .foregroundColor(Color(UIColor(red: 0.08, green: 0.26, blue: 0.44, alpha: 1.00)))
                }.padding()
                .padding(.bottom, 20)
                
                
            }
            
            
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
            
        
}


struct newView: View{
    
    
    var body: some View {
        ZStack{
            Color(UIColor(red: 0.08, green: 0.12, blue: 0.26, alpha: 1.00))
                .edgesIgnoringSafeArea(.all)
            LineChartView(data: [0.233,0.344,0.2343,0.323,0.533,0.2335,0.4], title: "cycles", style: Style.sleepStyle,form: ChartForm.medium,rateValue: 0, dropShadow: false)
            .frame(width: 400, height: 500)
            .padding()
            
            LineView(data: [8,23,54,32,12,37,7,23,43],
                                 title: nil,
                                 legend: nil,
                                 style: ChartStyle.init(backgroundColor: Color.white,
                                                        accentColor: Color.orange,
                                                        secondGradientColor: Color.blue,
                                                        textColor: Color.orange,
                                                        legendTextColor: Color.black,
                                                        dropShadowColor: Color.black),
                                 valueSpecifier:"%.0f")
                            .frame(width: .infinity, height: 400, alignment: .center)
                            .padding([.leading, .trailing], 16)
        }
    }
        
    }
}

struct sleepDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        sleepDisplayView(sleepData: randomTestDataForPreview, totalT: 3000, remnrem: [40000,3000])
    }
}
