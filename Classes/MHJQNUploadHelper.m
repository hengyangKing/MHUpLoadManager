//
//  MHJQNUploadHelper.m
//  musichome
//
//  Created by J on 16/5/20.
//  Copyright © 2016年 J. All rights reserved.
//

#import "MHJQNUploadHelper.h"
static MHJQNUploadHelper *_sharedInstance;

@implementation MHJQNUploadHelper
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[MHJQNUploadHelper alloc] init];
        
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}
+ (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}


@end
