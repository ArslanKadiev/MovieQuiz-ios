//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 12.06.2023.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}
