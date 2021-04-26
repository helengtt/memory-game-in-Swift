//
//  Concentration.swift
//  Concentration
//
//  Created by Huiming Guo on 23/2/21.
//

import Foundation


struct Concentration {
//  var cards = Array<Card>()
    var cards = [Card]() // removed 'private (set)' for Task 2: start a new game
    
//  Task 4: flip count does not belong in Controller, fix it.
    var flipCount = 0
    
//   Task 5: Give the game a random theme.
    private (set) var themes = [
        "🦇😱🙀😈👻🎃🍭🍬🍎",
        "🐼🐔🐴😺🙊🐶🐑🐤🐮",
        "🎾🏀🏈⚽️⚾️🏓🏸⛷🏏",
        "🤓😊😃😢😔😡🥱🤣😜",
        "🍇🥭🍓🍑🍅🍌🍒🥝🍍",
        "⚡️☀️☔️⛄️🌈⛅️🌋⭐️🌛"
    ]
    
    var score = 0  //  Task 6: Add a game score
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
//            Method 3: use of Optional
            return  cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly


//            Method 2: use of closures
//            let faceUpCardIndices = cards.indices.filter {cards[$0].isFaceUp}
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
//            Method 1:
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // check if cards match
    mutating func handleMatchOrNot(index: Int) {
        let matchIndex = indexOfOneAndOnlyFaceUpCard!
        if cards[matchIndex] == cards[index] {
            cards[matchIndex].isMatched = true
            cards[index].isMatched = true
            score = score + 2
            print("Score: \(score)")
        } else { // if cards not match
            if (cards[matchIndex].cardClick > 1) {
                score = score - 1
                print("Score: \(score)")
            }
            if (cards[index].cardClick > 1) {
                score = score - 1
                print("Score: \(score)")
            }

        }
    }
    
    // check if cards match
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at:\(index)): chosen index not in the cards")
        
//      Task 6: Add a game score
        // count clicks for each card
        cards[index].cardClick += 1
        print("Card [\(index)] click: \(cards[index].cardClick)")
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                handleMatchOrNot(index: index)
                cards[index].isFaceUp = true
//                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no card or 2 cards are face up
                
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
            // += works with arrays, the array is also a struct, so the two added cards are the same copy
        }
        
        //Task 3: Shuffle the cards
        cards.shuffle()
        
    }
}

// Method 3: use of Optional
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
