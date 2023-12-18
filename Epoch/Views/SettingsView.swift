//
//  SettingsView.swift
//  Epoch
//
//  Created by Justin Arnold on 12/9/23.
//

import Foundation
import AVFoundation
import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("baseTimeInMinutes") private var baseTimeInMinutes: Int = 25
    @AppStorage("selectedAlarmSound") private var selectedAlarmSound: String = "default.wav"
    
    @State private var audioPlayer: AVAudioPlayer?
    
    let timeOptions = Array(1...60)
    let wavFiles = loadSoundFiles()
    
    func playSound(soundName: String) {
        // Directly use the file name without any string manipulation
        let soundNameWithoutExtension = soundName.components(separatedBy: ".wav").first ?? soundName

        // Attempt to construct the URL for the sound file
        guard let url = Bundle.main.url(forResource: soundNameWithoutExtension, withExtension: "wav", subdirectory: "Alarms") else {
            print("Could not find the Library/Sounds directory.")
            return
        }

        print("URL for sound file: \(url)")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error setting up audio session or playing sound: \(error)")
        }
    }

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    Picker("Base Time", selection: $baseTimeInMinutes) {
                        ForEach(timeOptions, id: \.self) { time in
                            Text("\(time) minutes")
                        }
                    }
                }
                Section(header: Text("Alarm Sound")) {
                    Picker("Select Sound", selection: $selectedAlarmSound) {
                        ForEach(wavFiles, id: \.self) { wavFile in
                            Text(wavFile)
                        }
                    }
                    Button("Play Sound") {
                        playSound(soundName: selectedAlarmSound)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
    
}

func loadSoundFiles() -> [String] {
    guard let folderURL = Bundle.main.resourceURL?.appendingPathComponent("Alarms", isDirectory: true) else {
        print("Could not find the Library/Sounds directory.")
        return []
    }
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let wavFiles = fileURLs.filter { $0.pathExtension == "wav" }.map { $0.deletingPathExtension().lastPathComponent }
        print("Found MP3 files: \(wavFiles)") // Debugging statement
        return wavFiles
    } catch {
        print("Error while enumerating files \(folderURL.path): \(error.localizedDescription)")
        return []
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
