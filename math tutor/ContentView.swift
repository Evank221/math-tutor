//
//  ContentView.swift
//  math tutor
//
//  Created by HARO, EVAN on 1/27/26.
//

import SwiftUI
import AVFAudio
struct ContentView: View {
    @State private var firstnumber = 0
    @State private var secondnumber = 0
    @State private var firstnumberemojis = ""
    @State private var secondnumberemojis = ""
    @State private var answer = ""
    @State private var audioplayer: AVAudioPlayer!
    @State private var buttonisdisabled = false
    @State private var textfieldisdisabled = false
    @State private var message = ""
    @FocusState private var isfocused: Bool
    private let emojies = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group {
                Text(firstnumberemojis)
                Text("+")
                Text(secondnumberemojis)
            }
            .font(Font.system(size: 80))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .animation(.default, value: message)
            
            Spacer()
            
            Text("\(firstnumber) + \(secondnumber) =")
                .font(.largeTitle)
                .animation(.default, value: message)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($isfocused)
                .disabled(textfieldisdisabled)
            
            Button("guess"){
        //TODO: button action
                isfocused = false
                guard let answerValue = Int(answer) else {
                    return
                }
                if answerValue == firstnumber + secondnumber {
                    playSound(soundName: "correct")
                    message = "correct"
                } else {
                    playSound(soundName: "wrong")
                    message = " sorry, the correct answer is \(firstnumber + secondnumber)"
                }
                textfieldisdisabled = true
                buttonisdisabled = true
                
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || buttonisdisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "correct" ? .green : .red)
                .animation(.default, value: message)
            
            if message != "" {
                Button("play again?"){
                    message = ""
                    answer = ""
                    textfieldisdisabled = false
                    buttonisdisabled = false
                    genEquation()
                }
            }
        }
        .padding()
        .onAppear{
            genEquation()
        }
    }
    
    func playSound(soundName: String){
        guard let soundFile = NSDataAsset (name: soundName) else{
            print("error: could not read file name")
            return
        }
        do{
            audioplayer = try AVAudioPlayer(data: soundFile.data)
            audioplayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) creating audioPlayer")
            
        }
    }
    func genEquation(){            firstnumber = Int.random(in: 1...10)
        secondnumber = Int.random(in: 1...10)
        firstnumberemojis = String(repeating: emojies.randomElement()!, count: firstnumber)
        secondnumberemojis = String(repeating: emojies.randomElement()!, count: secondnumber)
        
    }
}

#Preview {
    ContentView()
}
