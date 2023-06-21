//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 12.06.2023.
//

import Foundation

protocol AlertPresenterProtocol {
    func showAlert (alertModel: AlertModel) -> Void
    var delegate: MovieQuizProtocolDelegate? {get}
}
