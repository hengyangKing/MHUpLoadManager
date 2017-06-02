//
//  MHJQNSystemService.m
//  musichome
//
//  Created by J on 16/5/20.
//  Copyright © 2016年 J. All rights reserved.
//

#import "MHJQNSystemService.h"
#import "MHJQNUploadHelper.h"

#define upLoadKey @"musichomeimage"
@implementation MHJQNSystemService
+ (QNUploadManager *) shareManager {
    static QNUploadManager *upManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        upManager = [[QNUploadManager alloc] init];
    });
    return upManager;
}


/**
 *  单张图片上传方法
 *
 *  @param image      image
 *  @param tokenModel tokenModel
 *  @param progress   进度
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)MHJ_uploadImage:(UIImage *)image andTokenModel:(MHJQiNiuTokenModel *)tokenModel progress:(QNUpProgressHandler)progress  success:(void (^)(NSDictionary *dic))success failure:(void(^)())failure
{
    if (!image) {
        return;
    }
    NSData *imageData=UIImageJPEGRepresentation(image, 1);
    if (!imageData) {
        if (failure) {
            failure();
        }
        return;
    }
    /**
     *  生成一个单例
     */
    QNUploadManager *upManager = [[self class] shareManager];
    //显示上传的百分比
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        MHJLog(@"percent == %.2f", percent);
        
    } params:nil checkCrc:NO cancellationSignal:nil];
    
    [upManager putData:imageData key:tokenModel.key token:tokenModel.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

        if (info.statusCode==200&&resp)
        {
            NSMutableDictionary *mDic=[NSMutableDictionary dictionary];
//            //向词典中动态添加数据
            [mDic setObject:key forKey:@"resource"];
            if (tokenModel)
            {
                [mDic setObject:[NSNumber numberWithInteger:tokenModel.type] forKey:@"type"];
            }
            MHJLog(@"上传成功返回Dic%@",mDic);
            if (success) {
                success(mDic);
            }
        } else {
            if (failure) {
                
                failure();
            }
        }
    } option:uploadOption];
}

+(void)MHJ_UploadImages:(NSArray *)imageArray tokenModels:(NSArray <MHJQiNiuTokenModel *>*)modelArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSMutableArray *array=[NSMutableArray array];
    __block float totalProgress = 0.0f;
    __block float partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    MHJQNUploadHelper *uploadHelper = [MHJQNUploadHelper sharedInstance];
    
    __weak typeof(uploadHelper ) weakHelper = uploadHelper;
    
    weakHelper.singleFailureBlock = ^() {
        failure();
        return ;
    };

    uploadHelper.singleSuccessBlock = ^(NSDictionary *dic) {
        
        [array addObject:dic];
        totalProgress += partProgress;
        progress(totalProgress);
        
        if (array.count == imageArray.count) {
            success([array copy]);
            return ;
        } else {

            currentIndex ++;
            MHJLog(@"currentIndex == %ld", (unsigned long)currentIndex);
            [MHJQNSystemService MHJ_uploadImage: imageArray[currentIndex]andTokenModel:modelArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };

    [MHJQNSystemService MHJ_uploadImage:imageArray[0] andTokenModel:modelArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
    
 
}

+(void)MHJ_UploadMedias:(NSDictionary * )medias tokenModels:(NSArray <MHJQiNiuTokenModel *>*)modelArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    if (medias.count !=2) {
        return;
    }
   __block NSURL *mediaFilePath;
   __block UIImage *seleteImage;
    [medias enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[self MHUploadSeleteImageKey]]&&[obj isKindOfClass:[UIImage class]]) {
            seleteImage=(UIImage *)obj;
        }else if ([key isEqualToString:[self MHUploadMediaFilePathKey]]&&[obj isKindOfClass:[NSURL class]]){
            mediaFilePath=(NSURL *)obj;
        }
    }];
    
    
    
    NSMutableArray *array=[NSMutableArray array];
    MHJQiNiuTokenModel *imageTokenModel;
    MHJQiNiuTokenModel *mediaTokenModel;
    for (MHJQiNiuTokenModel *object in modelArray)
    {
        if ([object.bucket isEqualToString:upLoadKey]){
            imageTokenModel=object;
        }else{
            mediaTokenModel=object;
        }
    }
    
    MHJQNUploadHelper *uploadHelper = [MHJQNUploadHelper sharedInstance];
    
    __weak typeof(uploadHelper ) weakHelper = uploadHelper;
    weakHelper.singleFailureBlock = ^() {
        failure();
        return ;
    };
    uploadHelper.progressBlock=^(float pro)
    {
        if (progress)
        {
            progress(pro);
        }
    };
    uploadHelper.singleSuccessBlock=^(NSDictionary *dic) {
    
        [array addObject:dic];
        if (array.count == modelArray.count) {
            success([array copy]);
            return ;
        } else {

            [MHJQNSystemService MHJ_uploadMedia:mediaFilePath  andTokenModel:mediaTokenModel progress:weakHelper.progressBlock success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }};
    
    [MHJQNSystemService MHJ_uploadImage:seleteImage andTokenModel:imageTokenModel progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];

}




/**
 *  上传媒体方法
 *
 *  @param media      流媒体文件
 *  @param tokenModel tokenModel
 *  @param progress   进度
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)MHJ_uploadMedia:(NSURL *)media andTokenModel:(MHJQiNiuTokenModel *)tokenModel progress:(void(^)(float progress))progress  success:(void (^)(NSDictionary *dic))success failure:(void(^)())failure
{
    if (!media) {
        return;
    }
    NSData *mediaData=[NSData dataWithContentsOfURL:media];
    if (!mediaData) {
        if (failure) {
            failure();
        }
        return;
    }
    
    QNUploadManager *upManager = [[self class] shareManager];
//    NSDictionary*params=[MHJQNUploadHelper SetUpAudioParamsWith:tokenModel];
    QNUploadOption *uploadOption=[[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        MHJLog(@"percent == %.2f AND KEY==%@", percent,key);
        if (progress)
        {
            progress(percent);
        }
    } params:nil checkCrc:NO cancellationSignal:nil];
    
        [upManager putData:mediaData key:tokenModel.key token:tokenModel.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            MHJLog(@"resp:::%@",resp);
            MHJLog(@"info:::%@",info);
            if (info.statusCode==200&&resp)
            {
                NSString *url = [NSString stringWithFormat:@"%@/%@", tokenModel.bucket, resp[@"key"]];
                MHJLog(@"url === %@", url);
                NSMutableDictionary *mDic=[NSMutableDictionary dictionary];
                //            //向词典中动态添加数据
                [mDic setObject:key forKey:@"resource"];
                if (tokenModel)
                {
                    [mDic setObject:[NSNumber numberWithInteger:tokenModel.type] forKey:@"type"];
                }
                MHJLog(@"上传成功返回Dic%@",mDic);
                if (success) {
                    success(mDic);
                }
            } else {
                
                if (failure) {
                    failure();
                }
            }
        } option:uploadOption];
    
}
+(NSString *)MHUploadMediaFilePathKey
{
    return @"MHUploadMediaFilePathKey";
}
+(NSString *)MHUploadSeleteImageKey
{
    return @"MHUploadSeleteImageKey";
}



@end
