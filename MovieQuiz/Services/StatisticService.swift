import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard

    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }

    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }

    var totalAccuracy: Double {
        let correct = Double(storage.integer(forKey: Keys.totalCorrectAnswers.rawValue))
        let total = Double(storage.integer(forKey: Keys.totalQuestionsAsked.rawValue))
        return total > 0 ? (correct / total) * 100 : 0
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    func store(correct count: Int, total amount: Int) {
        let newTotalQuestionsAsked = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) + amount
        storage.set(newTotalQuestionsAsked, forKey: Keys.totalQuestionsAsked.rawValue)

        let newTotalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) + count
        storage.set(newTotalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        
        self.gamesCount += 1

        let currentGameResult = GameResult(correct: count, total: amount, date: Date())

        if currentGameResult.isBetterThan(bestGame) {
            self.bestGame = currentGameResult
        }
    }
}
