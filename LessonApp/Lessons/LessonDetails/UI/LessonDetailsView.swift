import Foundation
import UIKit
import SDWebImage

class LessonDetailsView: UIView {

    private enum Constants {
        static let videoPreviewHeight: CGFloat = 300.00
        static let titleLabelTopMargin: CGFloat = 20.00
        static let titleLabelNumberOfLines: Int = 3
        static let descriptionLabelTopMargin: CGFloat = 10.00
        static let contentLeadingMargin: CGFloat = 10.00
        static let contentTrailingMargin: CGFloat = -10.00
        static let playButtonSize: CGFloat = 80.0
    }

    var videoPreviewView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var nextLessonButton: UIButton!
    var playButton: UIButton!
    var downloadButton: UIButton!

    var uiModel: UiModel?
    var uiActionModel: UiActionModel?

    enum DownloadState {
        case completed
        case downloading
        case notDownloaded
    }

    override init(frame: CGRect) {
        super.init(frame:frame)
    }

    convenience init() {
        self.init(frame: .zero)
        initializeView()
        addConstraints()
    }

    func setupViews(
        uiModel: UiModel,
        uiActionModel: UiActionModel
    ) {
        self.uiModel = uiModel
        self.uiActionModel = uiActionModel
        videoPreviewView.sd_setImage(with: URL(string: uiModel.thumbnailUrl))
        titleLabel.text = uiModel.titleLabel
        descriptionLabel.text = uiModel.descriptionLabel

        nextLessonButton.isHidden = uiModel.isNextLessonButtonHidden
        switchDownloadState(state: uiModel.downloadState)

        nextLessonButton.addTarget(self, action: #selector(nextLessonButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playVideoButtonTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func nextLessonButtonTapped() {
        guard let uiActionModel = uiActionModel else {
            return
        }
        uiActionModel.nextLessonAction?()

    }

    @objc func playVideoButtonTapped() {
        guard let uiActionModel = uiActionModel else {
            return
        }
        uiActionModel.playVideoAction?()

    }

    @objc func downloadButtonTapped() {
        guard let uiActionModel = uiActionModel else {
            return
        }
        switchDownloadState(state: .downloading)
        uiActionModel.downloadButtonAction?()
    }

    func switchDownloadState(state: DownloadState) {
        switch (state) {
            case .notDownloaded:
                configureDownloadButton()
            case .completed:
                configureDownloadedButton()
        case .downloading:
                downloadButton.isHidden = true
            break
        }
    }

    func configureDownloadButton() {
        downloadButton.isHidden = false
        downloadButton.isUserInteractionEnabled = true
        var downloadButtonConfig = UIButton.Configuration.plain()
        downloadButtonConfig.image = UIImage(systemName: "icloud.and.arrow.down.fill")
        downloadButtonConfig.imagePadding = 5
        downloadButtonConfig.imagePlacement = .leading
        downloadButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        downloadButton.configuration = downloadButtonConfig
        downloadButton.setTitle("Download", for: .normal)
    }

    func configureDownloadedButton() {
        downloadButton.isHidden = false
        downloadButton.isUserInteractionEnabled = false
        var downloadButtonConfig = UIButton.Configuration.plain()
        downloadButtonConfig.image = UIImage(systemName: "checkmark.icloud")
        downloadButtonConfig.imagePadding = 5
        downloadButtonConfig.imagePlacement = .leading
        downloadButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        downloadButton.setTitle("", for: .normal)
        downloadButton.configuration = downloadButtonConfig
    }
}

// MARK: - Layout

extension LessonDetailsView {
    func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        videoPreviewView = .init()
        videoPreviewView.translatesAutoresizingMaskIntoConstraints = false
        videoPreviewView.contentMode = .scaleAspectFill
        videoPreviewView.clipsToBounds = true

        addSubview(videoPreviewView)

        titleLabel = .init()
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = Constants.titleLabelNumberOfLines
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        addSubview(titleLabel)

        descriptionLabel = .init()
        descriptionLabel.textColor = .label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = .zero

        addSubview(descriptionLabel)

        nextLessonButton = .init(type: .system)
        nextLessonButton.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePadding = 5
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        nextLessonButton.configuration = config
        
        nextLessonButton.setTitle("Next Lesson", for: .normal)
        nextLessonButton.tintColor = .tintColor
        nextLessonButton.setTitleColor(.tintColor, for: .normal)


        addSubview(nextLessonButton)

        let playImage: UIImage? = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        if let playImage = playImage {
            playButton = .systemButton(with: playImage, target: nil, action: nil)
        }
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.tintColor = .tintColor
        playButton.backgroundColor = .systemGray
        addSubview(playButton)
        bringSubviewToFront(playButton)


        downloadButton = .init(type: .system)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        configureDownloadButton()
        downloadButton.tintColor = .tintColor
        downloadButton.setTitleColor(.tintColor, for: .normal)
        addSubview(downloadButton)





    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            videoPreviewView.topAnchor.constraint(equalTo: topAnchor),
            videoPreviewView.leftAnchor.constraint(equalTo: leftAnchor),
            videoPreviewView.rightAnchor.constraint(equalTo: rightAnchor),
            videoPreviewView.centerXAnchor.constraint(equalTo: centerXAnchor),
            videoPreviewView.heightAnchor.constraint(equalToConstant: Constants.videoPreviewHeight)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(
                equalTo: leftAnchor,
                constant: Constants.contentLeadingMargin
            ),
            titleLabel.rightAnchor.constraint(
                equalTo: rightAnchor,
                constant: Constants.contentTrailingMargin
            ),
            titleLabel.topAnchor.constraint(
                equalTo: videoPreviewView.bottomAnchor,
                constant: Constants.titleLabelTopMargin
            )
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(
                equalTo: leftAnchor,
                constant: Constants.contentLeadingMargin
            ),
            descriptionLabel.rightAnchor.constraint(
                equalTo: rightAnchor,
                constant: Constants.contentTrailingMargin
            ),
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.descriptionLabelTopMargin
            )
        ])

        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: videoPreviewView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: videoPreviewView.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: Constants.playButtonSize),
            playButton.widthAnchor.constraint(equalToConstant: Constants.playButtonSize)
        ])

        NSLayoutConstraint.activate([
            nextLessonButton.rightAnchor.constraint(equalTo: rightAnchor),
            nextLessonButton.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: Constants.titleLabelTopMargin
            ),
            nextLessonButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)

        ])

        NSLayoutConstraint.activate([
            downloadButton.leftAnchor.constraint(equalTo: leftAnchor),
            downloadButton.topAnchor.constraint(
                equalTo: nextLessonButton.topAnchor
            ),
            downloadButton.bottomAnchor.constraint(equalTo: nextLessonButton.bottomAnchor),
            downloadButton.heightAnchor.constraint(equalTo: nextLessonButton.heightAnchor)
        ])

    }
}

extension LessonDetailsView {
    struct UiModel {
        var thumbnailUrl: String
        var titleLabel: String
        var descriptionLabel: String
        var videoURL: String
        var downloadState: DownloadState = .notDownloaded
        var isNextLessonButtonHidden: Bool = false
    }

    struct UiActionModel {
        var nextLessonAction: (() -> Void)? = nil
        var playVideoAction: (() -> Void)? = nil
        var downloadButtonAction: (() -> Void)? = nil
    }
}
