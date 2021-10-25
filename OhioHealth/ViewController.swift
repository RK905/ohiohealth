//
//  ViewController.swift
//  OhioHealth
//
//  Created by Rayen Kamta on 10/22/21.
//

import UIKit
import AVFoundation
import Speech
class ViewController: UIViewController {
    //MARK: - Local Properties
    let audioEngine = AVAudioEngine()
    let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task : SFSpeechRecognitionTask!
    var isStart : Bool = false
    var buttonp : Int = 0
    
    @IBOutlet weak var lb_speech: UITextField!
     @IBOutlet weak var view_color: UIView!
     @IBOutlet weak var btn_start: UIButton!
    @IBOutlet weak var citybtn_start: UIButton!
    @IBOutlet weak var citylb_speech: UITextField!
    @IBOutlet weak var datebtn_start: UIButton!
    @IBOutlet weak var datelb_speech: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let utterance = AVSpeechUtterance(string: "Hello Ohio Health!")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)

        
        self.requestTranscribePermissions()
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func btn_start_stop(_ sender: Any) {
        self.buttonp = 0
          //MARK:- Coding for start and stop sppech recognization...!
          isStart = !isStart
          if isStart {
              startSpeechRecognization()
              btn_start.setTitle("STOP", for: .normal)
              btn_start.backgroundColor = .systemGreen
          }else {
              cancelSpeechRecognization()
              btn_start.setTitle("START", for: .normal)
              btn_start.backgroundColor = .systemOrange
          }
      }
    
    @IBAction func citybtn_start_stop(_ sender: Any) {
        self.buttonp = 1
          //MARK:- Coding for start and stop sppech recognization...!
          isStart = !isStart
          if isStart {
              startSpeechRecognization()
              self.citybtn_start.setTitle("STOP", for: .normal)
              self.citybtn_start.backgroundColor = .systemGreen
          }else {
              cancelSpeechRecognization()
              self.citybtn_start.setTitle("START", for: .normal)
              self.citybtn_start.backgroundColor = .systemOrange
          }
      }
    
    @IBAction func datebtn_start_stop(_ sender: Any) {
        self.buttonp = 2
          //MARK:- Coding for start and stop sppech recognization...!
          isStart = !isStart
          if isStart {
              startSpeechRecognization()
              self.datebtn_start.setTitle("STOP", for: .normal)
              self.datebtn_start.backgroundColor = .systemGreen
          }else {
              cancelSpeechRecognization()
              self.datebtn_start.setTitle("START", for: .normal)
              self.datebtn_start.backgroundColor = .systemOrange
          }
      }
    
    
    

        func cancelSpeechRecognization() {
            task.finish()
//            task.cancel()
//            task = nil
            
            request.endAudio()
            audioEngine.stop()
            //audioEngine.inputNode.removeTap(onBus: 0)
            
            //MARK: UPDATED
            if audioEngine.inputNode.numberOfInputs > 0 {
                audioEngine.inputNode.removeTap(onBus: 0)
            }
        }

     
    func alertView(message: String){
        let controller = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    func startSpeechRecognization(){
          let node = audioEngine.inputNode
          let recordingFormat = node.outputFormat(forBus: 0)
          
          node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
              self.request.append(buffer)
          }
          
          audioEngine.prepare()
          do {
              try audioEngine.start()
          } catch let error {
              alertView(message: "Error comes here for starting the audio listner =\(error.localizedDescription)")
          }
          
          guard let myRecognization = SFSpeechRecognizer() else {
              self.alertView(message: "Recognization is not allow on your local")
              return
          }
          
          if !myRecognization.isAvailable {
              self.alertView(message: "Recognization is free right now, Please try again after some time.")
          }
          
          task = speechReconizer?.recognitionTask(with: request, resultHandler: { (response, error) in
              guard let response = response else {
                  if error != nil {
                      self.alertView(message: error.debugDescription)
                  }else {
                      self.alertView(message: "Problem in giving the response")
                  }
                  return
              }
              
              let message = response.bestTranscription.formattedString
              print("Message : \(message)")
              switch self.buttonp {
              case 0:
                  self.lb_speech.text = message
              case 1:
                  self.citylb_speech.text = message
              case 2:
                  self.datelb_speech.text = message
              default:
                  print("Message : \(message)")
              }
              
              
//              var lastString: String = ""
//              for segment in response.bestTranscription.segments {
//                  let indexTo = message.index(message.startIndex, offsetBy: segment.substringRange.location)
//                  lastString = String(message[indexTo...])
//              }
//
//              if lastString == "red" {
//                  self.view_color.backgroundColor = .systemRed
//              } else if lastString.elementsEqual("green") {
//                  self.view_color.backgroundColor = .systemGreen
//              } else if lastString.elementsEqual("pink") {
//                  self.view_color.backgroundColor = .systemPink
//              } else if lastString.elementsEqual("blue") {
//                  self.view_color.backgroundColor = .systemBlue
//              } else if lastString.elementsEqual("black") {
//                  self.view_color.backgroundColor = .black
//              }
              
              
          })
      }

    
    @IBAction func saveData(_ sender: Any) {
       
        if self.lb_speech.text != "" && self.citylb_speech.text != "" && self.datelb_speech.text != "" {
            let jsonmodel = ohiohealthmodel(city: self.citylb_speech.text!, name: self.lb_speech.text!, date: self.datelb_speech.text!)
            // Prepare URL
            let url = URL(string: "https://ohiohealth.rayenkamta.com/new.php")
            guard let requestUrl = url else { fatalError() }
            // Prepare URL Request Object
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            // Set HTTP Request Headers
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(jsonmodel)
                request.httpBody = jsonData
            }
            catch {
            }
            
        
            // Perform HTTP Request
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Check for Error
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
             
                    // Convert HTTP Response Data to a String
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                    }
            }
            task.resume()
        }else {
            self.alertView(message: "Make Sure All Fields are filled in")
        }
        
  
    }


    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
}

struct ohiohealthmodel: Codable {
    var city: String
    var name: String
    var date: String
}
