//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 26.06.2023.
//

import UIKit



final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswer: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
    func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
        
    func switchToNextQuestion() {
            currentQuestionIndex += 1
        }

    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
         
    func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            let text = "Ваш  результат: \(correctAnswer)/10"
            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            viewController?.show(quiz: viewModel)
            
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            
//            imageView.layer.masksToBounds = true
//            imageView.layer.borderWidth = 0
//            noButton.isEnabled = true
//            yesButton.isEnabled = true
            questionFactory?.requestNextQuestion()
        }
    }
    
    func yesButtonClicked() {
            didAnswer(isYes: true)
        }
        
    func noButtonClicked() {
            didAnswer(isYes: false)
        }
        
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
                return
            }
            
        let givenAnswer = isYes
            
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
