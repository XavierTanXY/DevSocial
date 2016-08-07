//
//  PostCell.swift
//  dev-social
//
//  Created by Xhien Yi Tan on 6/08/2016.
//  Copyright © 2016 Xavier TanXY. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 2024, completion: { (data,error) in
                if error != nil {
                    print("Xavier: unable to dowload image from fire")
                } else {
                    print("Xavier: image dowloaded from fire")
                    if let imageData = data {
                        if let img = UIImage(data: imageData){
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl)
                        }
                        
                    }
                }
                    
            })
        }
    }


}
