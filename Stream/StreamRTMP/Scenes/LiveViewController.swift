//
//  LiveViewController.swift
//  StreamRTMP
//
//  Created by Александр Арсенюк on 11.10.2022.
//

import AVFoundation
import HaishinKit
import Photos
import UIKit
import VideoToolbox

class LiveViewController: UIViewController {
    
    @IBOutlet weak var lfView: MTHKView!
    
    public var rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var currentPosition: AVCaptureDevice.Position = .back
    
    private var settings: SettingsModel {
        return Defaults.shared.settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        setupView()
        prepareSession()
        setupStream()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startStream()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopStream()
    }
    
    private func setupView() {
        view.backgroundColor = .cyan
    }
    
    private func prepareSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
                    AVAudioSession.CategoryOptions.allowBluetooth,
                    AVAudioSession.CategoryOptions.defaultToSpeaker]
                )
                try session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func setupStream() {
        rtmpStream = RTMPStream(connection: rtmpConnection)
        
        rtmpStream.captureSettings = [
            .sessionPreset: AVCaptureSession.Preset.hd4K3840x2160,
            .fps: 60
        ]
        
        rtmpStream.videoSettings = [
            .width: settings.resolution.reversed().width,
            .height: settings.resolution.reversed().height,
            .profileLevel: kVTProfileLevel_H264_High_AutoLevel
        ]
        rtmpStream.mixer.recorder.delegate = self
    }
    
    private func startStream() {
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            print(error.description)
        }
        
        rtmpStream.attachCamera(AVCaptureDevice.default(for: .video)) { error in
            print(error.description)
        }
        
        
        lfView?.attachStream(rtmpStream)
        
        rtmpConnection.connect(settings.serverAddress)
        rtmpStream.publish(settings.servername)
    }
    
    private func stopStream() {
        rtmpConnection.close()
        rtmpStream.close()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}


extension LiveViewController: AVRecorderDelegate {
    // MARK: AVRecorderDelegate
    func recorder(_ recorder: AVRecorder, errorOccured error: AVRecorder.Error) {
        //        logger.error(error)
    }
    
    func recorder(_ recorder: AVRecorder, finishWriting writer: AVAssetWriter) {
        PHPhotoLibrary.shared().performChanges({() -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: writer.outputURL)
        }, completionHandler: { _, error -> Void in
            do {
                try FileManager.default.removeItem(at: writer.outputURL)
            } catch {
                print(error)
            }
        })
    }
    
}
