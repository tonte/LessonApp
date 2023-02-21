import AVKit
import Combine
import Foundation
import UIKit

class LessonDetailsViewController: UIViewController {
    var viewModel: LessonDetailsViewModel?
    var lessonDetailsView: LessonDetailsView!
    var downloadProgressView: UIAlertController?
    private var progressBinding: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()

    public init (viewModel: LessonDetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        initializeView()
        addConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {
        viewModel?.$isLessonDownloading.sink(receiveValue: { [weak self] result in
            if result {
                self?.showProgress()
            }
            else {
                self?.hideProgress()
            }
        })
        .store(in: &subscriptions)
    }

    func changeLesson() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.showNextLesson()
        refreshView()
    }

    func showVideo() {
        guard let viewModel = viewModel, let videoURL = viewModel.getLessonVideo() else {
            return
        }
        let player = AVPlayer(url: videoURL)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.player?.play()
        present(vc, animated: true)
    }


    func downloadButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.downloadVideo()
    }

    func cancelDownloadButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.cancelDownload()
        progressBinding?.cancel()
        refreshView()
    }

    func refreshView() {
        guard let viewModel = viewModel else { return }
        lessonDetailsView?.setupViews(
            uiModel: viewModel.fetchLessonUIModel(),
            uiActionModel: .init(
                nextLessonAction: {[weak self] in
                    self?.changeLesson()
                },
                playVideoAction: {[weak self] in
                    self?.showVideo()
                },
                downloadButtonAction: {[weak self] in
                    self?.downloadButtonTapped()
                }
            )
        )
    }

    func showProgress() {
        downloadProgressView = UIAlertController(
            title: "Downloading".localizedCapitalized,
            message: "Please wait".localizedCapitalized,
            preferredStyle: .alert
        )
        downloadProgressView?.addAction(
            UIAlertAction(
                title: "Cancel".localizedCapitalized,
                style: .cancel,
                handler: { _ in
                    self.cancelDownloadButtonTapped()
                }
            )
        )
        guard let downloadProgressView = downloadProgressView else {
            return
        }

        present(downloadProgressView, animated: true, completion: {
            let progressView = UIProgressView(frame: .zero)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            guard let viewModel = self.viewModel else {
                return
            }
            self.progressBinding = viewModel.$downloadProgress.assign(to: \.progress, on: progressView)
            progressView.tintColor = .tintColor
            downloadProgressView.view.addSubview(progressView)
            NSLayoutConstraint.activate([
                progressView.heightAnchor.constraint(equalToConstant: 2.0),
                progressView.leftAnchor.constraint(
                    equalTo: downloadProgressView.view.leftAnchor
                ),
                progressView.rightAnchor.constraint(
                    equalTo: downloadProgressView.view.rightAnchor
                ),
                progressView.bottomAnchor.constraint(
                    equalTo: downloadProgressView.view.bottomAnchor,
                    constant: -45.0
                )
            ])
        })
    }

    func hideProgress() {
        downloadProgressView?.dismiss(animated: true, completion: { [weak self] in
            self?.progressBinding?.cancel()
            self?.refreshView()
        })
    }
}

// MARK: - Layout

extension LessonDetailsViewController {
    func initializeView() {
        view.backgroundColor = .systemBackground
        lessonDetailsView = LessonDetailsView()
        refreshView()
        guard let lessonDetailsView = lessonDetailsView  else { return }
        view.addSubview(lessonDetailsView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            lessonDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            lessonDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lessonDetailsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lessonDetailsView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}
