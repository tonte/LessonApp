import Foundation
import Combine


protocol DownloadManagerDelegate {
    func downloadProgressChanged(percentage: Float, downloadUrl: URL?)
    func downloadComplete(from: URL?, to: URL?)
}

protocol DownloadManagerProtocol {
    func download(from url: URL)
    func cancelDownload(from url: URL)
    var delegate: DownloadManagerDelegate? { get set }
}

class DownloadManager: NSObject, URLSessionDownloadDelegate, DownloadManagerProtocol {
    var delegate: DownloadManagerDelegate?
    var currentDownloads: [URLSessionDownloadTask] = []

    func download(from url: URL) async {

        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let downloadTask = session.downloadTask(with: url)
        currentDownloads.append(downloadTask)
        downloadTask.resume()
    }

    func download(from url: URL) {

        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let downloadTask = session.downloadTask(with: url)
        currentDownloads.append(downloadTask)
        downloadTask.resume()
    }

    func cancelDownload(from url: URL) {
        for task in currentDownloads {
            if task.originalRequest?.url == url {
                task.cancel()
                currentDownloads.removeAll(where: { $0 == task })
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        currentDownloads.removeAll(where: { $0 == downloadTask })
        delegate?.downloadComplete(from: downloadTask.originalRequest?.url, to: location)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded: Float = Float(
            Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)

        )
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.downloadProgressChanged(
                percentage: percentDownloaded,
                downloadUrl: downloadTask.originalRequest?.url
            )
        }

    }
}
