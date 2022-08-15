//
//  TestViewController.swift
//  Digits_in_Noise
//
//  Created by Daniel Senga on 2022/08/13.
//

import UIKit

class TestViewController: UIViewController {
    var numberLabels = [UILabel]()
    var numbersArray = [String]()
    var newNumArr = [String]()
    
    @IBOutlet weak var testPrint: UILabel!
    
    @IBOutlet weak var numberLabelView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layoutLabels()
        showTest()
    }
    
    func layoutLabels() {
        let width = 100
        let height = 50
        
        // create 10 labels as a 5x2 grid
        for row in 0..<5 {
            for col in 0..<2 {
                
                let numberLabel = UILabel()
                numberLabel.font = numberLabel.font.withSize(25)
                
                numberLabel.text = "___"
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                numberLabel.frame = frame
                
                numberLabelView.addSubview(numberLabel)
                
                numberLabels.append(numberLabel)
                
            }
        }
    }
    
    @IBAction func onRunTest(_ sender: Any) {
        
        // Generate random numbers & store each value in variable
        for i in 0..<numberLabels.count {
            let randomNum = Int.random(in: 1..<10)
            let randomNum2 = Int.random(in: 1..<10)
            let randomNum3 = Int.random(in: 1..<10)
            
            // store sequence as string
            let randomSequence = String(randomNum) + String(randomNum2) + String(randomNum3)
            
            
            numberLabels[i].text = randomSequence
            
            numbersArray.append(numberLabels[i].text!)
        }
    }
    
    @IBAction func onUploadTest(_ sender: Any) {
        saveToJsonFile()
    }
    
    private func showTest() {
        retrieveFromFile()
        testPrint.text = newNumArr.joined(separator: ",")
    }
    
    
    private func saveToJsonFile() {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Screening Test.json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: numbersArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
        
        postResults()
    }
    
    private func retrieveFromFile() {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Screening Test.json")
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let numbersArr = try JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
            newNumArr = numbersArr
        } catch {
            print(error)
        }
        
    }
    
    private func postResults() {
        var testCount = 0
        var semaphore = DispatchSemaphore (value: 0)
        let parameters =
            "{\n    \"score\": 10,\n    \"rounds\": [\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[0])\",\n            \"triplet_answered\": \"\(newNumArr[0])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[1])\",\n            \"triplet_answered\": \"\(newNumArr[1])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[2])\",\n            \"triplet_answered\": \"\(newNumArr[2])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[3])\",\n            \"triplet_answered\": \"\(newNumArr[3])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[4])\",\n            \"triplet_answered\": \"\(newNumArr[4])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[5])\",\n            \"triplet_answered\": \"\(newNumArr[5])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[6])\",\n            \"triplet_answered\": \"\(newNumArr[6])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[7])\",\n            \"triplet_answered\": \"\(newNumArr[7])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[8])\",\n            \"triplet_answered\": \"\(newNumArr[8])\"\n        },\n        {\n            \"difficulty\": 1,\n            \"triplet_played\": \"\(newNumArr[9])\",\n            \"triplet_answered\": \"\(newNumArr[9])\"\n        }\n    ]\n}"
        
        print(parameters)
        
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://enoqczf2j2pbadx.m.pipedream.net")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
          testCount += 1
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    print("screening test 1 - uploaded results (200)")
                    return
                }
            }
        }

        task.resume()
        semaphore.wait()
        
        
        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        } catch let error {
//            print(error.localizedDescription)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard
//                let response = response as? HTTPURLResponse,
//                error == nil
//            else {                                                               // check for fundamental networking error
//                print("error", error ?? URLError(.badServerResponse))
//                return
//            }
//
//            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                return
//            }
//
//        }
//
//        task.resume()

        
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
