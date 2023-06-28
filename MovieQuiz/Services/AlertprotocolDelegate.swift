//
//  AlertprotocolDelegate.swift
//  MovieQuiz
//
//  Created by Арслан Кадиев on 28.06.2023.
//

import UIKit

protocol AlertProtocolDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag:Bool,
                 completion: (() ->Void)?)
}
