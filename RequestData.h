//
//  RequestData.h
//  NomalWeather
//
//  Created by 常昊 on 16/10/9.
//  Copyright © 2016年 常昊. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol requestDataDelegate <NSObject>


- (void)needForRequest:(NSString *)requestWords andTheAnwser:(NSMutableDictionary *)dic ;

@end

@interface RequestData : NSObject
@property(strong,nonatomic)NSMutableData *receiveData;
@property(strong,nonatomic)NSArray *resault;
@property(strong,nonatomic)NSMutableDictionary *location;

@property (nonatomic,weak)id<requestDataDelegate>delegate;
@end
