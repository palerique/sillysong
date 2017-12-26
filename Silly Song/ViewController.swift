//
//  ViewController.swift
//  Silly Song
//
//  Created by Paulo Henrique Lerbach Rodrigues on 24/12/17.
//  Copyright © 2017 Paulo Henrique Lerbach Rodrigues. All rights reserved.
//

import UIKit
import Foundation

let fullNameRegex = "<FULL_NAME>"
let shortNameRegex = "<SHORT_NAME>"

let bananaFanaTemplate = [
    "<FULL_NAME>, <FULL_NAME>, Bo B<SHORT_NAME>",
    "Banana Fana Fo F<SHORT_NAME>",
    "Me My Mo M<SHORT_NAME>",
    "<FULL_NAME>"].joined(separator: "\n")

func shortNameFromName(name: String) -> String {
    let lowercaseName = name.lowercased()
    let vowelSet = CharacterSet(charactersIn: "aeiou")
    var result = lowercaseName
    
    if(result.folding(options: .diacriticInsensitive, locale: .current).rangeOfCharacter(from: vowelSet) == nil){
        return result
    }
    
    for char in lowercaseName {
        let withoutAccent = "\(char)".folding(options: .diacriticInsensitive, locale: .current)
        if(vowelSet.isSuperset(of: CharacterSet(charactersIn: withoutAccent))){
            break
        }
        result.remove(at: result.startIndex)
    }
    
    return result
}

func lyricsForName(lyricsTemplate: String, fullName: String) -> String {
    let shortname = shortNameFromName(name: fullName)
    return lyricsTemplate
        .replacingOccurrences(of: fullNameRegex, with: fullName, options: .regularExpression)
        .replacingOccurrences(of: shortNameRegex, with: shortname, options: .regularExpression)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lyricsView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reset(_ sender: Any) {
        nameField.text = ""
        lyricsView.text = ""
    }
    
    @IBAction func displayLyrics(_ sender: Any) {
        let fullName = nameField.text
        
        if(fullName != nil && !(fullName?.isEmpty)!){
            lyricsView.text = lyricsForName(lyricsTemplate: bananaFanaTemplate, fullName: fullName!)
        }
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

