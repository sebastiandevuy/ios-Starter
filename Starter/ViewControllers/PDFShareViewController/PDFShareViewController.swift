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
        
//        let downloadTask = session.downloadTask(with: documentUrlRequest) { [weak self] location, _, error in
//            if let documentDonwloadLocation = location {
//                guard let data = try? Data(contentsOf: documentDonwloadLocation) else { return }
//                self?.loadFileAndPromptActivity(data)
//            }
//        }
//        downloadTask.resume()
        
        let dataTask = session.dataTask(with: documentUrlRequest) { [weak self] documentData, _, error in
            // Handle error. Not done here for validation purposes
            if let documentData = documentData {
                self?.loadFileAndPromptActivity(documentData)
            }
        }
        dataTask.resume()
    }
    
    private func createFileUrl(withName fileName: String,
                               fileExtension: String,
                               data: Data) throws -> URL {
        let file = "\(fileName).\(fileExtension)"
        let fileManager = FileManager.default
        let tempUrl = fileManager.temporaryDirectory
        let tempFileUrlWithName = tempUrl.appendingPathComponent(file)
        if fileManager.fileExists(atPath: tempFileUrlWithName.path) {
            try fileManager.removeItem(at: tempFileUrlWithName)
        }

        try data.write(to: tempFileUrlWithName)
        let url = URL(fileURLWithPath: tempFileUrlWithName.path)
        return url
    }
    
    private func loadFileAndPromptActivity(_ data: Data) {
        guard let fileUrl = try? createFileUrl(withName: "Receipt89345678", fileExtension: "pdf", data: data) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
