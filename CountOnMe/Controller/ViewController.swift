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

        // Listen notification on expression update in model
        let name = Notification.Name(rawValue: "UpdateExpression")
        NotificationCenter.default.addObserver(self, selector: #selector(updateExpression), name: name, object: nil)

        textView.text = ""
    }

    // Update textView on notification
    @objc func updateExpression() {
        textView.text = calc.expression
    }

    // Clear expression/textView on clear button tapped
    @IBAction func tappedClearButton(_ sender: UIButton) {
        // Clear expression in model
        calc.clearExpression()
    }

    // On numbers buttons tapped
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        // Get the number of button tapped
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        // Add number in expression
        calc.addNumber(numberText)
    }

    // On operators buttons tapped
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        // Get tapped operator
        guard let operatorText = sender.title(for: .normal) else {
            return
        }

        // Add operator in expression
        calc.addOperator(operatorText)
    }

    // On equal button tapped
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        // Get result
        do {
            // Try to get result
            try calc.result()
        } catch {
            // On error display alert
            let alertVC = UIAlertController(
                title: "Erreur CountOnMe",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
    }
}
