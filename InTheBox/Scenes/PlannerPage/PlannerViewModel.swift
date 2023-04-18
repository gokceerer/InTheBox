//
//  PlannerViewModel.swift
//  InTheBox
//
//  Created by G on 2023-04-14.
//

import Foundation
import UIKit

protocol PlannerViewModelProtocol {
    var delegate: PlannerViewModelDelegate?  { get set }
    var currentDate: Date { get set }

    func setupGreetingTitle()
    func setCurrentDate(with date: Date)
}

protocol PlannerViewModelDelegate {
    func handleViewModelOutput(_ output: PlannerViewModelOutput)
}

enum PlannerViewModelOutput {
    case setupGreetingTitle(String, UIImage?)
    case setupDateLabel(String)
}

final class PlannerViewModel: PlannerViewModelProtocol {
    var delegate: PlannerViewModelDelegate?
    var currentDate: Date = Date.now

    func setupGreetingTitle(){
        let currentHour = NSCalendar.current.component(.hour, from: Date.now)
        let greetingText: String
        var greetingImage = UIImage(named: "Morning")
        
        if currentHour >= 7 && currentHour <= 12 {
            greetingText = "Good Morning!"
            greetingImage = UIImage(named: "Morning")
        } else if currentHour >= 12 && currentHour <= 16 {
            greetingText = "Good Afternoon!"
            greetingImage = UIImage(named: "Afternoon")
        } else if currentHour >= 16 && currentHour <= 20 {
            greetingText = "Good Evening!"
            greetingImage = UIImage(named: "Night")
        } else if (currentHour >= 20 && currentHour <= 24) ||
                    (currentHour >= 0 && currentHour <= 7) {
            greetingText = "Good Night!"
            greetingImage = UIImage(named: "Night")
        } else {
            greetingText = "Hello!"
        }
        
        self.delegate?.handleViewModelOutput(.setupGreetingTitle(greetingText, greetingImage))
        
    }
}

extension PlannerViewModel {
    func setCurrentDate(with date: Date) {
        currentDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy - EEEE"
        self.delegate?.handleViewModelOutput(.setupDateLabel(formatter.string(from: date)))
    }
}
