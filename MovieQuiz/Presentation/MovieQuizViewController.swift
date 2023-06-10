import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

    private var currentQuestionIndex: Int = 0
 //   private lazy var currentQuestion = questions[currentQuestionIndex]
    private var correctAnswers = 0
    private var allowAnswer: Bool = true
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?

    
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        if allowAnswer == true {
            //let currentQuestion = questions[currentQuestionIndex]
            guard let currentQuestion = currentQuestion else {return}
            let giveAnswer = true
            
            showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
            allowAnswer = false
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if allowAnswer == true {
            //let currentQuestion = questions[currentQuestionIndex]
            guard let currentQuestion = currentQuestion else {return}
            let giveAnswer = false
            
            showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
            allowAnswer = false
        }
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // 4
        return questionStep
    }

    
    private func showAnswerResult(isCorrect: Bool){
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect == true {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswers += 1
        } else { imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
                    "Поздравляем, Вы ответили на 10 из 10!" :
                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
        
 //       if currentQuestionIndex == questionsAmount - 1 {
//            let text = "Ваш результат: \(correctAnswer)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            questionFactory?.requestNextQuestion()
           // let viewModel = convert(model: nextQuestion)
            allowAnswer = true
            //show(quiz: viewModel)
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
            self.correctAnswers = 0
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 0
            self.allowAnswer = true
            questionFactory?.requestNextQuestion()
          //  let viewModel = self.convert(model: firstQuestion)
          //  self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)

    }
    

    override func viewDidLoad() {
    
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        //show(quiz: convert(model: currentQuestion))
        //imageView.layer.cornerRadius = 20
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {[weak self] in
            self?.show(quiz: viewModel)
        }
        
        
    }
    
}








