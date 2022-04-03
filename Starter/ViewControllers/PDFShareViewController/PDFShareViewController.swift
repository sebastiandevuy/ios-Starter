//
//  PDFShareViewController.swift
//  Starter
//
//  Created by Pablo Gonzalez on 2/4/22.
//

import UIKit

class PDFShareViewController: UIViewController {
    let documentPathToLoad = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDocument()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func loadDocument() {
        let session = URLSession.shared
        guard let url = URL(string: documentPathToLoad) else { return }
        let documentUrlRequest = URLRequest(url: url)
        // If no download method is available just make an api call expecting Data
        let downloadTask = session.downloadTask(with: documentUrlRequest) { [weak self] location, response, error in
            // Handle error. Not done here for validation purposes
            if let documentDonwloadLocation = location {
                self?.loadFileAndPromptActivity(documentDonwloadLocation)
            }
        }
        downloadTask.resume()
    }
    
    private func loadFileAndPromptActivity(_ documentUrl: URL) {
        guard let documentData = NSData(contentsOf: documentUrl) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let activityViewController = UIActivityViewController(activityItems: [documentData], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
//    func doStuff() {
//        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
//                        activityViewController.popoverPresentationController?.sourceView=self.view
//                        present(activityViewController, animated: true, completion: nil)
//    }
}
