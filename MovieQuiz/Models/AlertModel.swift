import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
    
    init(quizResult: QuizResultsViewModel, statisticInfo: String, completion: @escaping () -> Void) {
            self.title = quizResult.title
            self.message = quizResult.text + statisticInfo
            self.buttonText = quizResult.buttonText
            self.completion = completion
        }
}
