import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private var unusedQuestions: [QuizQuestion] = []
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            correctAnswer: false)
    ]
    
    func requestNextQuestion() {
        if unusedQuestions.count < 1 {
            unusedQuestions = questions
        }
        guard let index = (0..<unusedQuestions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = unusedQuestions[safe: index]
        unusedQuestions.remove(at: index)
        delegate?.didReceiveNextQuestion(question: question)
    }
}
