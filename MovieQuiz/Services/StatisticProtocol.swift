//
//  StatisticProtocol.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 28.06.2023.
//

import Foundation


protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
