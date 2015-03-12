//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Corpac on 3/10/15.
//  Copyright (c) 2015 Jeff Corpac. All rights reserved.
//
import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }

    @IBAction func playChipmunkAudio(sender: UIButton){
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb(25)
    }
    
    func playAudio(playRate:Float) {
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.stop()
        audioPlayer.rate = playRate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Attach existing AudioPlayerNode to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Set the timePitch with the new Pitch and attach it to the engine
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        // Connect the audioPlayerNode to the timePitch, then the timePitch to the output Node
        audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        // Set the audioPlayerNode to the audioFile
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        // Start the audioEngine
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(wetDryMix: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Attach existing AudioPlayerNode to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Set the timePitch with the new Pitch and attach it to the engine
        var reverbMixer = AVAudioUnitReverb()
        reverbMixer.wetDryMix = wetDryMix
        audioEngine.attachNode(reverbMixer)
        
        // Connect the audioPlayerNode to the reverbMixer, then the reverbMixer to the output Node
        audioEngine.connect(audioPlayerNode, to: reverbMixer, format: nil)
        audioEngine.connect(reverbMixer, to: audioEngine.outputNode, format: nil)
        
        // Set the audioPlayerNode to the audioFile
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Start the audioEngine
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
}
