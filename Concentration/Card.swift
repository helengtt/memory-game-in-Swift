//
//  Card.swift
//  Concentration
//
//  Created by Huiming Guo on 25/2/21.
//

import Foundation

struct Card:Hashable
{
    var hashValue: Int {return identifier}
    
    static func ==(lhs:Card, rhs:Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var cardClick = 0   // Task 6: Add a game score
    
    private static var identiferFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
//        Card.identiferFactory += 1
//        return Card.identiferFactory
//        // Because in a static method, you can access your static vars without the Card..
        identiferFactory += 1
        return identiferFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
