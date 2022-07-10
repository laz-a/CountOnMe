//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    let calc: Calculator = Calculator()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        textView.text = ""
    }

    @IBAction func tappedClearButton(_ sender: UIButton) {
        textView.text = ""
        calc.expression = ""
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        calc.expression = textView.text

        if calc.lastResult != nil {
            calc.lastResult = nil
            textView.text = ""
        }

        if calc.elements.last == "0" {
            if numberText == "0" {
                return
            } else {
                textView.text.removeLast()
            }
        }

        textView.text.append(numberText)
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }

        calc.expression = textView.text

        if let lastResult = calc.lastResult {
            textView.text = "\(lastResult)"
            calc.lastResult = nil
        }

        if calc.lastElementIsAnOperator {
            textView.text.removeLast(3)
        }

        textView.text.append(" \(operatorText) ")
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calc.expression = textView.text

        guard calc.expressionIsCorrect else {
            let alertVC = UIAlertController(
                title: "Zéro!",
                message: "Entrez une expression correcte !",
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        guard !calc.divisionByZero else {
            let alertVC = UIAlertController(
                title: "Zéro!",
                message: "Division par 0 interdit !",
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        if let result = calc.result {
            textView.text.append(" = \(result)")
        }
    }
}
