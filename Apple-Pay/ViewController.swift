import UIKit
import PassKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buyButton()
        payButton()
        donateButton()
        checkoutButton()
    }

    private func buyButton() {
        let paymentButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(paymentButton)

        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 40.0))
    }

    private func payButton() {
        let paymentButton = PKPaymentButton(paymentButtonType: .inStore, paymentButtonStyle: .black)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(paymentButton)

        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 90.0))
    }

    private func donateButton() {
        let paymentButton = PKPaymentButton(paymentButtonType: .donate, paymentButtonStyle: .black)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped2(sender:)), for: .touchUpInside)
        view.addSubview(paymentButton)

        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 140.0))
    }

    private func checkoutButton() {
        let paymentButton = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(paymentButton)

        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 190.0))
    }

    @objc private func applePayButtonTapped(sender: UIButton) {
        payNow()
    }

    @objc private func applePayButtonTapped2(sender: UIButton) {
        payNow2()
    }
}

extension ViewController {
    func payNow() {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: FakeData.paymentInfo()) {
            let request = Payment(id: FakeData.merchantInfo(),
                                  currency: FakeData.currencyInfo(),
                                  networks: FakeData.paymentInfo(),
                                  shipping: FakeData.shippingInfo().address,
                                  billing: FakeData.shippingInfo().address,
                                  methods: FakeData.shippingMethodInfo(),
                                  summary: FakeData.summaryInfo(),
                                  requiredFields: FakeData.shippingInfo().requiredFields).request
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)

            if let viewController = authorizationViewController {
                viewController.delegate = self
                present(viewController, animated: true, completion: nil)
            }
        }
    }

    func payNow2() {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: FakeData.paymentInfo()) {
            let request = Payment(id: FakeData.merchantInfo(),
                                  currency: FakeData.currencyInfo(),
                                  networks: FakeData.paymentInfo(),
                                  shipping: nil,
                                  billing: nil,
                                  methods: nil,
                                  summary: FakeData.summaryInfo(),
                                  requiredFields: []).request

            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)

            if let viewController = authorizationViewController {
                viewController.delegate = self
                present(viewController, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }

    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("🔑 \(payment.token.transactionIdentifier)")
        print("🔐 \(payment.token.paymentData)")

        for index in 1...5 {
            print("♲ InHouse API call ... \(index*20)% ♲")
            sleep(1)
        }

        guard Bool.random() else {
            print("❌ FAILURE ❌")
            completion(PKPaymentAuthorizationResult(status: .failure,
                                                    errors: [FakeData.fakeError()]))
            return
        }

        print("✅ SUCCESS ✅\n")
        return completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    public func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        print("🔓 User authenticated")
    }
}
