//
//  MHJQiNiuTokenModel.h
//  musichome
//
//  Created by J on 16/5/19.
//  Copyright © 2016年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHJQiNiuTokenModel : NSObject
/*{
    token = "DmJiA4GxYEx3h9TMNh1UwfxxuBn6U8Y-sO6R_lZ-:oLlxHGJewUrDD73yJ8V7x4EoEf0=:eyJzY29wZSI6Im11c2ljaG9tZWF1ZGlvOnVnY19jZDZmODY1ZWYyYmJmOTQ4ZjEzOTFhZDJiYmViZDdlNl8xNDY3NzEwOTM1NjY2IiwiZGVhZGxpbmUiOjE0Njc3MTQ1MzV9";
}*/

/**
 *  文件类型的容器
 */
@property(nonatomic,copy)NSString *bucket;
/**
 *  文件名
 */
@property(nonatomic,copy)NSString *key;
/**
 *  上传每一个文件的token
 */
@property(nonatomic,copy)NSString *token;
/**
 *  过期时间
 */
@property(nonatomic,copy)NSString *expires;
/**
 *  用户名
 */
@property(nonatomic,copy)NSString *uid;
/**
 *  上传任务类型
 */
@property(nonatomic,assign)TakeQiNiuTokenType type;



/***********新增音频上传时需要转码参数*************/
/**
 *  上传凭证有效截止时间
 */
@property(nonatomic,copy)NSString *deadline;

/**
 *  接收持久化处理结果通知的URL
 */
@property(nonatomic,copy)NSString *persistentNotifyUrl;

/**
 *  资源上传成功后触发执行的预转持久化处理指令列表。
 */
@property(nonatomic,copy)NSString *persistentOps;

/**
 *  转码队列名
 */
@property(nonatomic,copy)NSString *persistentPipeline;

/**
 *  指定上传的目标资源空间 (Bucket) 和资源键 (Key) 。
 */
@property(nonatomic,copy)NSString *scope;




@end
