//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 10.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
