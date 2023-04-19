import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
        activityIndicator.hidesWhenStopped = true
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        isEnabledButton(false)
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        isEnabledButton(false)
        presenter.yesButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        isEnabledButton(true)
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let alertModel = AlertModel(title: result.title,
                                    message: result.text + message,
                                    buttonText: result.buttonText) { [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(model: alertModel)
    }
    
    func colorImageBorder(isCorrectAnswer:Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
    }
    
    func clearImageBorder () {
        imageView.layer.borderWidth = 0
    }
    
    func showLoadingIndicator() {
        activityIndicator.backgroundColor = .lightGray.withAlphaComponent(0.5)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func isEnabledButton(_ isEnable:Bool) {
        noButton.isEnabled = isEnable
        yesButton.isEnabled = isEnable
    }
    
    func didFailToLoadImage() {
        let model = AlertModel(title: "Ошибка",
                               message: "Не удалось загрузить изображение",
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            self.presenter.didLoadDataFromServer()
        }
        alertPresenter.showAlert(model: model)
    }
    
    func showNetworkError(message: String) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
            self.presenter.startLoadData()
        }
        alertPresenter.showAlert(model: model)
    }
    
}
