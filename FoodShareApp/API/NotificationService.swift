//
//  NotificationService.swift
//  FoodShareApp
//
//  Created by 坂田一真 on 2021/05/13.
//

import Firebase

struct NotificationService {
    //MARK: お知らせをアップロードする機能
    static func uploadNotification(toUid uid:String,fromUser:User,type:NotificationType,post: Post? = nil){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUid else {return}
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data:[String:Any] = ["timestamp":Timestamp(date: Date()),
                                 "uid":fromUser.uid,
                                 "type":type.rawValue,"id":docRef.documentID,
                                 "userProfileImageUrl":fromUser.profileImageUrl,
                                 "username":fromUser.username]
        
        if let post = post{
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    //MARK: お知らせを取得する機能
    static func fetchNotification(completion:@escaping([Notification])->Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by: "timestamp",descending: true)
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            let notifications = documents.map({Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
}