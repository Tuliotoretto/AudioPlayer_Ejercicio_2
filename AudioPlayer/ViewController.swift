//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Julian Garcia  on 05/11/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var sliderDuration: UISlider!
    @IBOutlet weak var sliderVolume: UISlider!
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudio()
        
        btnStop.isEnabled = false
    }

    @IBAction func playbuttonPressed(_ sender: UIButton) {
        audioPlayer?.play()
        btnPlay.isEnabled = false
        btnStop.isEnabled = true
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        audioPlayer?.stop()
        btnPlay.isEnabled = true
        btnStop.isEnabled = false
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        audioPlayer?.volume = sender.value
    }
    
    @IBAction func durationSliderChanged(_ sender: UISlider) {
        audioPlayer?.currentTime = Double(sender.value)
    }
    
    func loadAudio() {
        guard let url = Bundle.main.url(forResource: "zelda", withExtension: "mp3") else {
            print("bad url")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            
            // UI Setup
            sliderDuration.value = 0.0
            sliderDuration.maximumValue = Float(audioPlayer!.duration)
            btnStop.isEnabled = false
            btnPlay.isEnabled = true
            
            // slider timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
            timer?.fire()
            
            
        } catch {
            print("Audio player error: \(error)")
        }
        
        
        
    }
    
    @objc func tick() {
        sliderDuration.value = Float(audioPlayer!.currentTime)
    }
}

// MARK: - AVAudioPlayerDelegate
extension ViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
    }
}
