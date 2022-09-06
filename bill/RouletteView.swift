//
//  RouletteView.swift
//  bill
//
//  Created by t&a on 2022/09/02.
//

import SwiftUI

struct RouletteView: View {
    // MARK: -　プロパティ
    @Binding var rouletteResult:String   // 割り勘にするメンバー名を格納
    @Binding var memberArray:[String]    // @AppStorage("member")の配列形式
    // MARK: -　プロパティ
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    
    @Environment(\.dismiss) var dismiss
    
    @State var isRotate = false
    // MARK: -　メソッド
    func rouletteStart(){
        if !memberArray.contains(where: {$0 == "割り勘"}){
            memberArray.append("割り勘")
        }
        var timer = Timer()  // 結果表示用
        var timer2 = Timer() // ランダム表示用
        var stop = false
        timer2 = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){ _ in
            rouletteResult = String(memberArray.randomElement()!)
            timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true){ _ in
                stop = true
            }
            if stop {
                timer.invalidate()  // タイマーストップ
                timer2.invalidate() // タイマーストップ
            }
        }
    }
    // MARK: -　メソッド
    
    var body: some View {
        
        VStack{
            
            Text("Roulette").font(.system(size:50)).foregroundColor(.gray)
                
            Spacer()
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addArc(center: .init(x: 0, y: 0),
                                radius: 100,
                                startAngle: Angle(degrees:200.0),
                                endAngle: Angle(degrees: 90),
                                clockwise: false)
                }
                .fill(.orange)
                .rotationEffect(Angle.degrees(isRotate ? 45 : 3330),anchor: .leading)
                .animation(.easeInOut(duration: 4), value: isRotate)
                .frame(width: 1, height: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addArc(center: .init(x: 0, y: 0),
                                radius: 100,
                                startAngle: Angle(degrees: 90),
                                endAngle: Angle(degrees: 180),
                                clockwise: false)
                }
                .fill(.green)  .rotationEffect(Angle.degrees(isRotate ? 45 : 3330),anchor: .leading)
                .animation(.easeInOut(duration: 4), value: isRotate)
                .frame(width: 1, height: 1)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addArc(center: .init(x: 0, y: 0),
                                radius: 100,
                                startAngle: Angle(degrees: 180),
                                endAngle: Angle(degrees: 270),
                                clockwise: false)
                }
                .fill(.cyan)
                .rotationEffect(Angle.degrees(isRotate ? 45 :3330),anchor: .leading)
                .animation(.easeInOut(duration: 4), value: isRotate)
                .frame(width: 1, height: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: abs(0), y: abs(0)))
                    path.addArc(center: .init(x: abs(0), y: abs(0)),
                                radius: 100,
                                startAngle: Angle(degrees: 270),
                                endAngle: Angle(degrees: 360),
                                clockwise: false)
                }
                .fill(.red)
                .rotationEffect(Angle.degrees(isRotate ? 45 : 3330),anchor: .leading)
                .animation(.easeInOut(duration: 4), value: isRotate)
                .frame(width: 1, height: 1)
                
            }.padding()
            
            Spacer()
            
            Group{
                if rouletteResult != ""{
                    if rouletteResult == "割り勘" {
                        Text("仲良く\(rouletteResult)しましょう..").fontWeight(.bold)
                    }else{
                        Text("\(rouletteResult)の全額奢り！").fontWeight(.bold)
                    }
                }
            }.padding()
                .frame(width: deviceWidth - 50)
                .background(.orange)
                .font(.system(size:19))
                .cornerRadius(5)
                .foregroundColor(.white)
                .padding()
            
            
            
            AdMobBannerView().frame( height:30)
                .padding(.bottom)
           
            
        }.navigationBarBackButtonHidden(true)
        .onAppear(){
            isRotate = true
            rouletteStart()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    memberArray.removeAll(where: {$0 == "割り勘"})
                    dismiss()
                }) {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("戻る")
                    }
                }
            }
        }
    }
}

struct RouletteView_Previews: PreviewProvider {
    static var previews: some View {
        RouletteView(rouletteResult: Binding.constant(""), memberArray: Binding.constant([]))
    }
}
