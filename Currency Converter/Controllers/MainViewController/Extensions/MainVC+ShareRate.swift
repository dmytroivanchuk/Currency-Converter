//
//  MainViewController+ShareRate.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension MainViewController {
    @objc func shareButtonPressed(_ sender: UIButton) {
        let bounds = rateCalculationView.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        rateCalculationView.drawHierarchy(in: bounds, afterScreenUpdates: false)
        if let img = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            let shareSheetVC = UIActivityViewController(activityItems: [img], applicationActivities: nil)

            // iPad support
            shareSheetVC.popoverPresentationController?.sourceView = sender
            shareSheetVC.popoverPresentationController?.sourceRect = sender.frame

            present(shareSheetVC, animated: true)
        }
    }
}
