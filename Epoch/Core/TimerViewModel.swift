//
//  TimerViewModel.swift
//  Epoch
//
//  Created by Justin Arnold on 12/16/23.
//

import Foundation

class TimerViewModel: ObservableObject {
    // Publish changes to the view
    @Published var timeRemaining: Int
    @Published var isActive: Bool = false

    private var baseTimeInSeconds: Int = 0
    private var startTime: Date?
    private var timer: Timer?

    init() {
        self.timeRemaining = baseTimeInSeconds
    }

    func startTimer() {
        startTime = Date()
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }

    func pauseTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            timeRemaining -= Int(elapsedTime)
        }
        startTime = nil
    }

    func resetTimer() {
        pauseTimer()
        timeRemaining = baseTimeInSeconds
    }
        
    func setBaseTime(_ baseTimeInSeconds: Int) {
        self.baseTimeInSeconds = baseTimeInSeconds
        self.timeRemaining = baseTimeInSeconds
    }

    func updateRemainingTime() {
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            timeRemaining = max(baseTimeInSeconds - Int(elapsedTime), 0)
            if timeRemaining == 0 {
                pauseTimer()
            }
        }
    }
}
