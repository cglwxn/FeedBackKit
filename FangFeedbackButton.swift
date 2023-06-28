//
//  FangFeedbackButton.swift
//  FangFeedBackButton
//
//  Created by cc on 2023/6/10.
//

import UIKit

class FangFeedbackButton: FangFeedbackView {
    enum LayoutDirection {
        case horizental
        case vertical
    }
    
    var title: String {
        set {
            self.setTitle(newValue)
        }
        
        get {
            return self.titleLabel.text ?? ""
        }
    }
    
    var image: UIImage? {
        set {
            self.setImage(newValue)
        }
        
        get {
            return self.imageView.image
        }
    }
    
    var titleColor: UIColor? {
        set {
            self.titleLabel.textColor = newValue
        }
        
        get {
            return self.titleLabel.textColor
        }
    }
    
    var tapCallBack: ((UIView, CGPoint) -> ())?
    
    var layoutDirection: LayoutDirection = .horizental
    var labelFrame: CGRect = .zero
    var imgFrame: CGRect = .zero
    
    lazy var titleLabel: UILabel = {
        let tmpLabel = UILabel(frame: .zero)
        tmpLabel.text = ""
        tmpLabel.font = .systemFont(ofSize: 15)
        tmpLabel.textColor = .black
        tmpLabel.textAlignment = .center
        return tmpLabel
    }()
    
    private lazy var contentView: UIView = {
        let tmpView = UIView(frame: self.bounds)
        return tmpView
    }()
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
        self.setupModeColors()
        self.setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        self.addSubview(self.contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupModeColors() {
        self.backgroundColor = .white
    }
    
    private func setupData() {
        self.touchEndCallBack = { [weak self] (view, touchPoint) in
            guard let self = self else  { return }
            self.tapCallBack?(view, touchPoint)
        }
    }
    
    private func setImage(_ image: UIImage?) {
        self.imageView.image = image
        guard let size = self.imageView.image?.size else { return }
        let textLen = self.titleLabel.intrinsicContentSize.width
        if self.layoutDirection == .horizental {
            if !CGRectEqualToRect(labelFrame, .zero), CGRectEqualToRect(imgFrame, .zero) {
                //only the label frame is setted by external
                self.contentView.frame = self.bounds
                self.titleLabel.frame = self.labelFrame
                self.imageView.frame = .init(x: CGRectGetMidX(labelFrame) - size.width,
                                             y: CGRectGetMidY(contentView.bounds) - size.height/2.0,
                                             width: size.width,
                                             height: size.height)
            } else if !CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                //only the image frame is setted by external
                self.contentView.frame = self.bounds
                self.imageView.frame = self.imgFrame
                self.titleLabel.frame = .init(x: CGRectGetMaxX(imgFrame),
                                             y: CGRectGetMidY(contentView.bounds) - titleLabel.font.pointSize/2.0,
                                             width: textLen,
                                             height: titleLabel.font.pointSize)
            } else if !CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                //the label frame & image frame is setted by external
                self.contentView.frame = self.bounds
                self.imageView.frame = self.imgFrame
                self.titleLabel.frame = self.labelFrame
            } else {
                let contentLen = size.width + textLen
                let contentHeight = max(size.height, titleLabel.font.pointSize)
                contentView.frame = .init(x: 0, y: 0, width: contentLen, height: contentHeight)
                let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                contentView.center = center
                imageView.frame = .init(x: 0, y: CGRectGetMidY(contentView.bounds) - size.height/2.0, width: size.width, height: size.height)
                titleLabel.frame = .init(x: CGRectGetMaxX(imageView.frame), y: CGRectGetMidY(contentView.bounds) - titleLabel.font.pointSize/2.0, width: textLen, height: titleLabel.font.pointSize)
            }
        } else {
            if !CGRectEqualToRect(labelFrame, .zero), CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                titleLabel.frame = labelFrame
                imageView.frame = .init(x: CGRectGetMinX(labelFrame) - size.width, y: CGRectGetMinY(labelFrame) - 3 - size.height, width: size.width, height: size.height)
            } else if CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                imageView.frame = imgFrame
                titleLabel.frame = .init(x: 0, y: CGRectGetMaxY(imgFrame) + 3, width: textLen, height: titleLabel.font.pointSize)
            } else if !CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                imageView.frame = imgFrame
                titleLabel.frame = labelFrame
            } else {
                let contentLen = max(size.width, textLen)
                let contentHeight = size.height + 3 + titleLabel.font.pointSize
                contentView.frame = .init(x: 0, y: 0, width: contentLen, height: contentHeight)
                let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                contentView.center = center
                imageView.frame = .init(x: CGRectGetWidth(contentView.bounds) - size.width/2.0, y: 0, width: size.width, height: size.height)
                titleLabel.frame = .init(x: 0, y: size.height + 3, width: CGRectGetWidth(contentView.bounds), height: titleLabel.font.pointSize)
            }
        }
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
        guard let size = imageView.image?.size else { return }
        let textLen = titleLabel.intrinsicContentSize.width
        if layoutDirection == .horizental {
            if !CGRectEqualToRect(labelFrame, .zero), CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                titleLabel.frame = labelFrame
                imageView.frame = .init(x: CGRectGetMidX(labelFrame) - size.width, y: CGRectGetMidY(contentView.bounds) - size.height/2.0, width: size.width, height: size.height)
            } else if CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                imageView.frame = imgFrame
                titleLabel.frame = .init(x: CGRectGetMaxX(imgFrame), y: CGRectGetMidY(contentView.bounds) - titleLabel.font.pointSize/2.0, width: textLen, height: titleLabel.font.pointSize)
            } else if !CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                imageView.frame = imgFrame
                titleLabel.frame = labelFrame
            } else {
                let contentLen = size.width + textLen
                let contentHeight = max(size.height, titleLabel.font.pointSize)
                contentView.frame = .init(x: 0, y: 0, width: contentLen, height: contentHeight)
                let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                contentView.center = center
                imageView.frame = .init(x: 0, y: CGRectGetMidY(contentView.bounds) - size.height/2.0, width: size.width, height: size.height)
                titleLabel.frame = .init(x: CGRectGetMaxX(imageView.frame), y: CGRectGetMidY(contentView.bounds) - titleLabel.font.pointSize/2.0, width: textLen, height: titleLabel.font.pointSize)
            }
        } else {
            if !CGRectEqualToRect(labelFrame, .zero), CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                titleLabel.frame = labelFrame
                imageView.frame = .init(x: CGRectGetMinX(labelFrame) - size.width, y: CGRectGetMinY(labelFrame) - 3 - size.height, width: size.width, height: size.height)
            } else if CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                imageView.frame = imgFrame
                titleLabel.frame = .init(x: 0, y: CGRectGetMaxY(imgFrame) + 3, width: textLen, height: titleLabel.font.pointSize)
            } else if !CGRectEqualToRect(labelFrame, .zero), !CGRectEqualToRect(imgFrame, .zero) {
                contentView.frame = self.bounds
                imageView.frame = imgFrame
                titleLabel.frame = labelFrame
            } else {
                let contentLen = max(size.width, textLen)
                let contentHeight = size.height + 3 + titleLabel.font.pointSize
                contentView.frame = .init(x: 0, y: 0, width: contentLen, height: contentHeight)
                let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidX(self.bounds))
                contentView.center = center
                self.imageView.frame = .init(x: (CGRectGetWidth(contentView.bounds) - size.width)/2.0, y: 0, width: size.width, height: size.height)
                self.titleLabel.frame = .init(x: 0, y: size.height + 3, width: CGRectGetWidth(contentView.bounds), height: titleLabel.font.pointSize)
            }
        }
    }
    
    
    
    
    
    
    
    
}






















































