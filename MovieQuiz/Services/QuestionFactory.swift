import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
   
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    private var unusedQuestions: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData(){
        self.movies = []
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        self.delegate?.showLoadingIndicator()
        if unusedQuestions.count < 1 {
            unusedQuestions = movies
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.unusedQuestions.count).randomElement() ?? 0
            guard let movie = self.unusedQuestions[safe: index] else { return }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadImage()
                }
                print("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let questionRating = Int.random(in: 7...9)
            let questionValue = Bool.random()
            let text = questionValue ? "Рейтинг этого фильма больше чем \(questionRating)?" : "Рейтинг этого фильма меньше чем \(questionRating)?"
            let correctAnswer = questionValue ? rating > Float(questionRating) : rating < Float(questionRating)
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            self.unusedQuestions.remove(at: index)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Dark Knight",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Kill Bill",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Avengers",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Deadpool",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Green Knight",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Old",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Ice Age Adventures of Buck Wild",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Tesla",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Vivarium",
//            correctAnswer: false)
//    ]
