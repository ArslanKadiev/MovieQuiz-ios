//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 28.06.2023.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
