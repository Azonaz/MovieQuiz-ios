import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func showNetworkError(message: String)
    func didFailToLoadImage()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func colorImageBorder(isCorrectAnswer: Bool)
    func clearImageBorder()
}


