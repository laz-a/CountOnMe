//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    // Instance of Calculator model
    let calc: Calculator = Calculator()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        textView.text = ""
    }

    // Clear expression/textView on clear button tapped
    @IBAction func tappedClearButton(_ sender: UIButton) {
        // Clear textView
        textView.text = ""

        // Clear expression in model
        calc.expression = ""
    }

    // On numbers buttons tapped
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        // Get the number of button tapped
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        // If lastResult exist, remove lastResul and clear textView
        if calc.lastResult != nil {
            calc.lastResult = nil
            textView.text = ""
        }

        // Prevent to start number with multiple 0
        if calc.elements.last == "0" {
            if numberText == "0" {
                return
            } else {
                textView.text.removeLast()
            }
        }

        // Update textView
        textView.text.append(numberText)

        // Update expression in model
        calc.expression = textView.text
    }

    // On operators buttons tapped
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        // Get tapped operator
        guard let operatorText = sender.title(for: .normal) else {
            return
        }

        // If lastResult exist, set lastResult as first element of expression
        if let lastResult = calc.lastResult {
            textView.text = "\(lastResult)"
            calc.lastResult = nil
        }

        // If last element of expression is an operator, remove this element from expression
        if calc.lastElementIsAnOperator {
            textView.text.removeLast(3)
        }

        // Uptade textView
        textView.text.append(" \(operatorText) ")

        // Update expression
        calc.expression = textView.text
    }

    // On equal button tapped
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calc.expression = textView.text

        // If expression is not correct, dipslay allert
        guard calc.expressionIsCorrect else {
            let alertVC = UIAlertController(
                title: "Expression incorrecte",
                message: "Entrez une expression valide !",
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        // If expression contain division by 0, alert error
        if calc.divisionByZero {
            let alertVC = UIAlertController(
                title: "Division par zéro",
                message: "Division par 0 interdit !",
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        // Get result and update textView
        if let result = calc.result {
            textView.text.append(" = \(result)")
        }
    }
}
