//
//  PostCell.swift
//  plants
//
//  Created by viplab on 2019/3/26.
//  Copyright © 2019年 viplab. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var voteButton: LineButton! {
        didSet {
            voteButton.tintColor = .red
        }
    }
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
        }
    }

    private var currentPost: Post?
    var postdetail : Post?
    
    var votepeople = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var votecount = 0
    @IBAction func heartClick(_ sender: Any) {
        if let user = postdetail?.postId {
            var postsRef = Database.database().reference().child("posts")
            var postRef = postsRef.child(user)
            
            if let postdetail = postdetail {
                postRef.updateChildValues(["imageFileURL": postdetail.imageFileURL,
                                            "timestamp": postdetail.timestamp,
                                            "user": postdetail.user,
                                            "votes":votecount + 1
                    
                    ])
                votecount = votecount + 1
                voteButton.setTitle("\(votecount)", for: .normal)
             }
        }
        
    }

    
    
    
    func configure(post: Post) {
        
        //設定目前的貼文
        currentPost = post
        postdetail = post
        
        //設定Cell樣式
        selectionStyle = .none
        
        //設定姓名與按讚樹
        nameLabel.text = post.user

        votecount = post.votes
        voteButton.setTitle("\(votecount)", for: .normal)
        voteButton.tintColor = .black
        
        //重設圖片視圖的圖片
        photoImageView.image = nil
        
        //下載貼文圖片
        if let image = CacheManager.shared.getFromCache(key: post.imageFileURL) as? UIImage {
            photoImageView.image = image
        }
        else {
            if let url = URL(string: post.imageFileURL) {
                let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, reponse, error) in
                    guard let imageData = data else{
                        return
                    }
                    OperationQueue.main.addOperation{
                        guard let image = UIImage(data: imageData) else {return}
                        if self.currentPost?.imageFileURL == post.imageFileURL{
                            self.photoImageView.image = image
                        }
                        
                        //加入下載圖片至快取
                        CacheManager.shared.cache(object: image, key: post.imageFileURL)
                    }
                })
                
                downloadTask.resume()
            }
        }
    }
}
