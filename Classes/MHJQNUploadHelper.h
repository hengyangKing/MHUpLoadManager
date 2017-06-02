//
//  MHJQNUploadHelper.h
//  musichome
//
//  Created by J on 16/5/20.
//  Copyright © 2016年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MHJQNUploadHelper : NSObject
/**
 *  成功回调
 */
@property (nonatomic, copy) void (^singleSuccessBlock)(NSDictionary *dic);
/**
 *  失败回调
 */
@property (nonatomic,copy) void (^singleFailureBlock)();
@property (nonatomic,copy) void (^ progressBlock)(float progress);
@property(nonatomic,assign)int x;

+ (instancetype)sharedInstance;


@end
