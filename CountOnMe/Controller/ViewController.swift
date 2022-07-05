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

        /*$$$$$$$$$$$$$$$$$*/
        calc.expression = "33 + 3 ÷ 20 + 5 x 5 - 99 ÷ 10"
        print(calc.expression)
        print(calc.elements)
        print(calc.expressionIsCorrect)
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
//        print(calc.result)
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

        textView.text.append(numberText)
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }

        calc.expression = textView.text

        print(calc.expression)
        print(calc.elements)
        print(calc.canAddOperator)

        if calc.canAddOperator {
            if let lastResult = calc.lastResult {
                calc.lastResult = nil
                textView.text = "\(lastResult)"
            }
            textView.text.append(" \(operatorText) ")
        } else {
            let alertVC = UIAlertController(
                title: "Zéro!",
                message: "Un operateur est déja mis !",
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calc.expression = textView.text

        print(calc.expression)
        print(calc.elements)

        guard calc.expressionIsCorrect else {
            let alertVC = UIAlertController(
                title: "Zéro!",
                message: "Entrez une expression correcte !",
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        if let result = calc.result {
            print(result)
            textView.text.append(" = \(result)")
        }
    }
}
