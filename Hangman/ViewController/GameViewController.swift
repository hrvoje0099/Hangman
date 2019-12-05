//
//  GameViewController.swift
//  Hangman
//
//  Created by Hrvoje Vuković on 01/11/2019.
//  Copyright © 2019 Hrvoje Vuković. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate {

    private var gameViewModel: GameViewModelProtocol
    
    private var tappedLetterButtons = [UIButton]()
    
    private lazy var gameView: GameView = {
        let gameView = GameView()
        gameView.delegate = self
        return gameView
    }()
    
    // MARK: - INIT
    
    init(viewModel: GameViewModelProtocol) {
        self.gameViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
    }
    
    // MARK: - BUTTON ACTION METHODS
    
    func backToStartView() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkIsTappedLetterInLookingWord(_ letterButton: UIButton) {
        disableAndAppendButtonInTappedLetterButtons(letterButton)
        checkLetterStatusAndChangeItsColor(letterButton)
        gameViewModel.checkIsGameFinished()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func fillUI() {
        
        //BINDS:
        
        gameViewModel.isUseShowHint.bindAndFire { [unowned self] (useShowHint: Bool) in
            if useShowHint {
                self.gameView.hintLabel.text = self.gameViewModel.hint
            }
        }
        
        gameViewModel.score.bindAndFire { [unowned self] in self.gameView.scoreLabel.text = $0 }
        gameViewModel.image.bindAndFire { [unowned self] in self.gameView.imageView.image = UIImage(named: $0) }
        gameViewModel.answere.bindAndFire({ [unowned self] in self.gameView.answerTextfield.text = $0 })
        
        gameViewModel.isFinished.bindAndFire { [weak self] (gameIsFinished: Bool) in
            if gameIsFinished {
                self?.createAlertController(actionHandler: { [weak self] (UIAlertAction) -> Void in
                    self?.startNewGame()
                })
            }
        }
        
    }
    
    private func createAlertController(actionHandler: ((UIAlertAction) -> Void)?) -> Void {
        let alertTitle = gameViewModel.alertTitle
        let alertMessage = gameViewModel.alertMessage
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: actionHandler))
        present(alertController, animated: true)
    }
    
    private func startNewGame() {
        gameViewModel.newWord()
        fillUI()
        enableAndRestoreTappedLetterButtons()
    }
    
    private func disableAndAppendButtonInTappedLetterButtons(_ letterButton: UIButton) {
        letterButton.isUserInteractionEnabled = false
        tappedLetterButtons.append(letterButton)
    }
    
    private func enableAndRestoreTappedLetterButtons() {
        for letterButton in tappedLetterButtons {
            letterButton.isUserInteractionEnabled = true
            letterButton.backgroundColor = .white
        }
        tappedLetterButtons.removeAll()
    }
    
    private func checkLetterStatusAndChangeItsColor(_ letterButton: UIButton) {
        guard let tappedLetter = letterButton.titleLabel?.text else { return }
        let letterStatus = gameViewModel.isCorrectLetterTapped(tappedLetter)
        letterButton.backgroundColor = letterStatus ? UIColor.green : UIColor.red
    }

}
