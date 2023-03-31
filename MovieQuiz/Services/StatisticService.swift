import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    func isGreaterThan(_ otherRecord: GameRecord) -> Bool {
        return self.correct > otherRecord.correct
    }
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var correct: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
                  let currentCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return currentCount
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.correct.rawValue)
        }
    }
    
    private var total: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let currentTotal = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return currentTotal
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard let correctData = userDefaults.data(forKey: Keys.correct.rawValue),
              let correct = try? JSONDecoder().decode(Int.self, from: correctData),
              let totalData = userDefaults.data(forKey: Keys.total.rawValue),
              let total = try? JSONDecoder().decode(Int.self, from: totalData) else {
            return 0
        }
        return Double(correct) / Double(total) * 100
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let currentCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return currentCount
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        if newRecord.isGreaterThan(bestGame) {
            bestGame = newRecord
        }
        correct += count
        total += amount
        gamesCount += 1
    }
}
