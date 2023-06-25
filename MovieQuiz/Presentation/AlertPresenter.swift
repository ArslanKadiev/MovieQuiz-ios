//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 12.06.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    func showAlert (alertModel: AlertModel) -> Void
    var delegate: MovieQuizProtocolDelegate? {get}
}


class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: MovieQuizProtocolDelegate?
    
    init (delegate: MovieQuizProtocolDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
            
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
            alertModel.complection()
        }
        alert.addAction(action)
        delegate?.presentAlert(alert: alert)
    }
}


