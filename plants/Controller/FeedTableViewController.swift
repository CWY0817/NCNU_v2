//
//  FeedTableViewController.swift
//  plants
//
//  Created by viplab on 2019/3/26.
//  Copyright © 2019年 viplab. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase

class FeedTableViewController: UITableViewController {
    
    var postfeed: [Post] = []
    fileprivate var isLoadingPost = false
    
    @IBAction func openCamera(_ sender: Any){
        if Auth.auth().currentUser != nil{
            let imagePickerController = ImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.imageLimit = 1
            present(imagePickerController, animated:true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title:"請先登入",message:"必須要先登入才能使用此功能",preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            present(alertController,animated:true,completion: nil)
        }

    }
    

    @IBAction func reload(sender: LineButton){
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設置下拉式更新
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.black
        refreshControl?.addTarget(self, action: #selector(loadRecentPosts), for: UIControlEvents.valueChanged)
        
        //載入目前貼文
        loadRecentPosts()
        
    }
    
    
    @objc fileprivate func loadRecentPosts() {
        
        isLoadingPost = true
        
        PostService.shared.getRecentPosts(start: postfeed.first?.timestamp, limit: 10) { (newPosts) in
            if newPosts.count > 0 {
                //加入貼文陣列至陣列的開始處
                self.postfeed.insert(contentsOf: newPosts, at:0)
            }
            
            self.isLoadingPost = false
            
            if let _ = self.refreshControl?.isRefreshing {
                // 為了讓動畫效果更佳,在結束更新之前延遲0.5秒
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                })
            }
            else{
                self.displayNewPosts(newPosts: newPosts)
            }
        }
    }
    
    private func displayNewPosts(newPosts posts: [Post]){
        //確認我們取得新的貼文來顯示
        guard posts.count > 0 else {
            return
        }
        
        //將它們插入表格視圖中來顯示貼文
        var indexPaths:[IndexPath] = []
        self.tableView.beginUpdates()
        for num in 0...(posts.count - 1){
            let indexPath = IndexPath(row: num, section: 0)
            indexPaths.append(indexPath)
        }
        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
    }

}

extension FeedTableViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        //取得第一張圖片
        guard let image = images.first else {
            dismiss(animated: true, completion: nil)
            
            return
        }
        
        //更新圖片至雲端
        PostService.shared.uploadImage(image:image) {
            self.dismiss(animated: true, completion: nil)
            self.loadRecentPosts()
        }
        

        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension FeedTableViewController {
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        //我們要在使用這滑到最後兩列時觸發這個載入
        guard !isLoadingPost, postfeed.count - indexPath.row == 2 else {
            return
        }
        
        isLoadingPost = true
        
        guard let lastPostTimestamp = postfeed.last?.timestamp else{
            isLoadingPost = false
            return
        }
        
        PostService.shared.getOldPosts(start: lastPostTimestamp, limit: 3){ (newPosts) in
            //加上新的貼文至目前陣列的表格視圖
            var indexPaths: [IndexPath] = []
            self.tableView.beginUpdates()
            for newPost in newPosts {
                self.postfeed.append(newPost)
                let indexPath = IndexPath(row: self.postfeed.count - 1, section: 0)
                indexPaths.append(indexPath)
            }
            self.tableView.insertRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
            
            self.isLoadingPost = false
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let currentPost = postfeed[indexPath.row]
        cell.configure(post: currentPost)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postfeed.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
