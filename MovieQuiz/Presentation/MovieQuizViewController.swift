import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, MovieQuizProtocolDelegate {
    
    
    
    // MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
   // private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
  //  private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
   // private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()

        showLoadingIndicator()
        questionFactory?.loadData()
        
    }
    
    // MARK: - MovieQuizProtocolDelegate
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert,animated: true, completion: nil)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) 
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
            presenter.didRecieveNextQuestion(question: question)
        }
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        guard let question = question else {
//            return
//        }
//
//        currentQuestion = question
//        let viewModel = presenter.convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//    }
    
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        
    }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
//    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect == true {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswer += 1
        } else { imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.presenter.correctAnswer = self.correctAnswer
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//            
//            let text = "Ваш  результат: \(correctAnswer)/10"
//            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
//            show(quiz: viewModel)
//            
//        } else {
//            presenter.switchToNextQuestion()
//            
//            imageView.layer.masksToBounds = true
//            imageView.layer.borderWidth = 0
//            noButton.isEnabled = true
//            yesButton.isEnabled = true
//            self.questionFactory?.requestNextQuestion()
//        }
//    }
    
    func show(quiz result: QuizResultsViewModel) {
        statisticService?.store(correct: correctAnswer, total: presenter.questionsAmount)
        let totalQuizCount = statisticService?.gamesCount ?? 0
        let recordCorrectAnswer = statisticService?.bestGame.correct ?? 0
        let recordTotalAnsweer = statisticService?.bestGame.total ?? 0
        let totalAccuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0)
        let date = statisticService?.bestGame.date ?? Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.YY HH:mm"
        let dateFormated = dateFormater.string(from: date)
        let alertModel = AlertModel(title: result.title, message: ("\(result.text) \n Количество сыгранных квизов: \(totalQuizCount) \n Рекорд: \(recordCorrectAnswer)/\(recordTotalAnsweer) (\(dateFormated)) \n Средняя точность: \(totalAccuracy)%") , buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.correctAnswer = 0
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 00
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter.showAlert(alertModel: alertModel)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswer = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.showAlert(alertModel: model)
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            presenter.noButtonClicked()
        }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            presenter.yesButtonClicked()
        }
}

