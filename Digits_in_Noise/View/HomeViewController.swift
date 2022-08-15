//
//  HomeViewController.swift
//  Digits_in_Noise
//
//  Created by Daniel Senga on 2022/08/13.
//

import UIKit

class HomeViewController: UIViewController {
    var resultsLabel = [UILabel]()
    var testResults = [String]()
    
    @IBOutlet weak var resultsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Digits in Noise"
        showTestResults()
    }
    

    private func showTestResults() {
        let width = 100
        let height = 50
        
        for row in 0..<5 {
            for col in 0..<2 {
                
                let resultLabel = UILabel()
                resultLabel.font = resultLabel.font.withSize(25)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                resultLabel.frame = frame
                
                resultsView.addSubview(resultLabel)
                
                resultsLabel.append(resultLabel)
            }
        }
        retrieveAndShowFromFile()
    }
    
    private func retrieveAndShowFromFile() {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("NoiseTest.json")
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let numbersArr = try JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
            testResults = numbersArr
        } catch {
            print(error)
        }
        
        for i in 0..<resultsLabel.count {
                resultsLabel[i].text = testResults[i]
        }
        
    }
    
    @IBAction func runTestButton(_ sender: Any) {
        performSegue(withIdentifier: "showTestVC", sender: sender)
    }
    

}
