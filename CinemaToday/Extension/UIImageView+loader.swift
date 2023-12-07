//
//  UIImageView+loader.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import UIKit

extension UIImageView {
  func loadImage(at url: String) {
    UIImageLoader.loader.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
