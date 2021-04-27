//
//  ViewController.swift
//  Concentration
//
//  Created by Huiming Guo on 20/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    //    var game: Concentration = Concentration()
    //    As of type inference, Swift can figure out from the line of code, the game is of type Concentration.
    private lazy var game = Concentration(numberOfPairsOfCards:numberOfPairsOfCards)

    private var numberOfPairsOfCards:Int {
        get {
            return  (cardButtons.count + 1) / 2
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes:[NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    // create cardButton array
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        game.flipCount += 1
//        print("flipCount:\(game.flipCount)")
        if let cardNumber = cardButtons.firstIndex(of: sender) {
        //  flipCard(withEmoji: emojiChoices[cardNumber], on: sender    )
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            allCardsFlipped ()
        } else {
            print("chosen card was not in cardButtons")
        }

    }
    
    private func updateViewFromModel () {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
//            print(card)
            if card.isFaceUp {
                button.setTitle(emoji(for:card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateScoreLabel ()
    }
    
//   Task 5: Give the game a random theme.
//    Method 1:
//    lazy var randomThemeIndex = Int.random(in: game.themes.indices)
//    lazy var emojiChoices = game.themes[randomThemeIndex]
//    Method 2:
    private lazy var emojiChoices = game.themes[game.themes.count.arc4random]
    
    //    var emoji = Dictionary<Int, String>()
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
        //            Method 1:
            //            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            //            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        //            Method 2: protocol
            //            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        //            Method 3:
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
//            print("emoji card:\(emoji[card])")
        }
    
//        Method 1:
    //      if emoji[card.identifier] != nil {
    //          return emoji[card.identifier]!
    //      } else {
    //          return "?"
    //      }
//        Method 2:
//        use ?? to create an expression which “defaults” to a value if an Optional is not set
        return emoji[card] ?? "?"

    }
    
//  Task 2: Start a new game
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            hiddenNewGameButton ()
        }
    }
    @IBAction func newGameButton(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards:numberOfPairsOfCards)
        emojiChoices = game.themes[game.themes.count.arc4random]
        updateViewFromModel ()
//        print(emojiChoices)
        hiddenNewGameButton ()
    }
    
    private func hiddenNewGameButton () {
        newGameButton.setTitle("", for: UIControl.State.normal)
        newGameButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    private func allCardsFlipped () {
        if game.cards.indices.filter({game.cards[$0].isFaceUp}).count == 2,
           game.cards.indices.filter({game.cards[$0].isMatched}).count == game.cards.count
        {
            newGameButton.setTitle("New Game", for: UIControl.State.normal)
            newGameButton.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        }
    }
    
//      Task 6: Add a game score
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel ()
        }
    }
    
    private func updateScoreLabel () {
        scoreLabel.text = "Score: \(game.score)"
    }

}




extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

