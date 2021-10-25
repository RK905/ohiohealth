//
//  rViewController.swift
//  OhioHealth
//
//  Created by Rayen Kamta on 10/25/21.
//

import UIKit
import AVFoundation
import Speech


class rViewController: UIViewController {

    @IBOutlet weak var nametf: UITextField!
    @IBOutlet weak var datetf: UITextField!
    @IBOutlet weak var citytf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func translatePressed(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: self.citytf.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    
    
    @IBAction func getData(_ sender: Any) {
        
        let url = URL(string: "https://ohiohealth.rayenkamta.com/fetch.php")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let ohioModel = try JSONDecoder().decode(ohiohealthmodel.self, from: data)
                    print("City: \(ohioModel.city)")
                    DispatchQueue.main.async {
                        self.citytf.text = ohioModel.city
                        self.nametf.text = ohioModel.name
                        self.datetf.text = ohioModel.date
                    }
                }catch let jsonErr{
                    print(jsonErr)
               }
         
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
