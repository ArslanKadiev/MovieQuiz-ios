import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

    private var currentQuestionIndex: Int = 0
    private lazy var currentQuestion = questions[currentQuestionIndex]
    private var correctAnswer = 0
    private var allowAnswer: Bool = true

    
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        if allowAnswer == true {
            let currentQuestion = questions[currentQuestionIndex]
            let giveAnswer = true
            
            showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
            allowAnswer = false
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if allowAnswer == true {
            let currentQuestion = questions[currentQuestionIndex]
            let giveAnswer = false
            
            showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
            allowAnswer = false
        }
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // 4
        return questionStep
    }

    
    private func showAnswerResult(isCorrect: Bool){
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect == true {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswer += 1
        } else { imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswer)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            allowAnswer = true
            show(quiz: viewModel)
        }
    }
    
    private func show(quiz step:QuizStepViewModel){
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    private func show(quiz result: QuizResultsViewModel) {
  
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 0
            self.allowAnswer = true
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)

    }
    

    override func viewDidLoad() {
    
        super.viewDidLoad()
        show(quiz: convert(model: currentQuestion))
        imageView.layer.cornerRadius = 20
    }
    
    private let questions: [QuizQuestion] = [
        
        QuizQuestion(
            image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Old", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "Tesla", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]

}

struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

struct QuizQuestion {
  
  let image: String
  let text: String
  let correctAnswer: Bool
}



