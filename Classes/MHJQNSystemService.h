//
//  MHJQNSystemService.h
//  musichome
//
//  Created by J on 16/5/20.
//  Copyright © 2016年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHJQiNiuTokenModel.h"
#import "QiniuSDK.h"

@interface MHJQNSystemService : NSObject
/**
 *  上传单个图片的方法
 *
 *  @param image      图片
 *  @param tokenModel tokenModel
 *  @param progress   进度
 *  @param success    成功的回调，返回云端url
 *  @param failure    失败的回调
 */
+(void)MHJ_uploadImage:(UIImage *)image andTokenModel:(MHJQiNiuTokenModel *)tokenModel progress:(QNUpProgressHandler)progress  success:(void (^)(NSDictionary *dic))success failure:(void(^)())failure;

/**
 *  批量上传图片方法
 *
 *  @param imageArray 图片的数组
 *  @param modelArray tokenModelArray
 *  @param progress   进度
 *  @param success    成功
 *  @param failure    失败
 */
+(void)MHJ_UploadImages:(NSArray *)imageArray tokenModels:(NSArray <MHJQiNiuTokenModel *>*)modelArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure;

/**
 *  批量上传流媒体方法
 *
 *  @param mediaModel 装有流媒体信息的模型
 *  @param modelArray tokenarray
 *  @param progress   进度
 *  @param success    成功
 *  @param failure    失败
 */
+(void)MHJ_UploadMedias:(NSDictionary * )medias tokenModels:(NSArray <MHJQiNiuTokenModel *>*)modelArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure;


/**
 *  上传单个媒体方法
 *
 *  @param media      媒体文件
 *  @param tokenModel tokenModel
 *  @param progress   进度
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)MHJ_uploadMedia:(NSURL *)media andTokenModel:(MHJQiNiuTokenModel *)tokenModel progress:(void(^)(float progress))progress  success:(void (^)(NSDictionary *dic))success failure:(void(^)())failure;




+(NSString *)MHUploadMediaFilePathKey;

+(NSString *)MHUploadSeleteImageKey;

@end
