import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadImage()
    func didFailToLoadData(with error: Error)
    func showLoadingIndicator()
}
