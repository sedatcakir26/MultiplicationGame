//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Sedat Çakır on 26.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var multiNumber = 0
    @State private var index = 0
    @State private var questionCount = 5
    @State private var isStartGame = false
    @State private var isGameFinished = false
    @State private var questionIndex = 0
    @State private var answer =  ""
    @State private var trueAnswer = -1
    @State private var someArray = [Question]()
    @State private var randomNumber = 1
    @State private var playerAnswers = [Int]()
    @State private var isThereAnswer = false
    @State private var score = 0
    // @State private var realScore = 0.0
    @State private var isAnswersTrue = [Bool]()
    @State private var animationAmount = 0.0
    @FocusState private var inputIsFocused : Bool
    @FocusState private var amountIsFocused : Bool
    
    let questionCounts = [5,10,20]
    
    
    struct Question{
        let question : String
        let answer : Int
    }
    
    var body: some View {
            NavigationView{
                Form{
                    Section{
                        Text("Please select which multiplication tables you want")
                        Stepper("\(multiNumber)" ,value: $multiNumber, in: 1...10)
                    }
                    Section {
                        Text("How much question do you want to answer?")
                        
                        Picker("", selection: $questionCount) {
                            ForEach(questionCounts, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    if isStartGame{
                        Section{
                            HStack{
                                Text(someArray[index].question)
                                TextField("Please enter your answer", text:  $answer).keyboardType(.decimalPad).focused($amountIsFocused).onSubmit(){
                                    withAnimation {
                                        animationAmount += 360
                                    }
                                    changeQuestion()
                                }
                            }  .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0, z: 0))
                        }
                    }
                    
            } .navigationTitle("Multiplication Game")
                    .toolbar{
                    ToolbarItem(placement: .bottomBar){
                        Button("Start Game"){
                            generateNumber()
                            startGame()
                        }
                    }
                }
            
        }
        .alert("Your score is \(score)/\(questionCount)", isPresented: $isGameFinished){
            Button("RESTART GAME", action: restartGame)
        }
    }
    
    func restartGame(){
        index = 0
        score = 0
    }
    
    func startGame(){
        inputIsFocused = true
        isStartGame.toggle()
        score = 0
        isAnswersTrue.removeAll()
        
    }
    func changeQuestion(){
        amountIsFocused = true
        answer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        let answerInt = Int(answer) ?? 0
        playerAnswers.insert(answerInt, at: index)
        
        
        if answerInt == someArray[index].answer {
            isAnswersTrue.insert(true, at: index)
            print(true)
        }
        else{
            isAnswersTrue.insert(false, at: index)
            print(false)
        }
        
        index+=1
        answer = " "
        
        if(index == questionCount){
            index = 0
            isStartGame.toggle()
            isGameFinished.toggle()
            calculateScore()
        }
    }
    
    func generateNumber(){
        for number in 0..<questionCount{
            randomNumber = Int.random(in: 1..<11)
            
            trueAnswer =  multiNumber * randomNumber
            someArray.insert(Question(question: "\(multiNumber) x \(randomNumber) =", answer: trueAnswer), at: number)
            print(trueAnswer)
        }
        
    }
    func calculateScore(){
        print(isAnswersTrue.count)
        print("Calculate Score")
        for val in isAnswersTrue {
            if val {
                score+=1
            }
        }
        //realScore = (Double(score) / Double(questionCount)) * 100
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

