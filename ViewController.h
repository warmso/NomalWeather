//
//  ViewController.h
//  NomalWeather
//
//  Created by 常昊 on 16/10/7.
//  Copyright © 2016年 常昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ViewController : UIViewController
@property NSString* nameOfTopCity;
@property NSString* tempr;
@property NSString* theWeather;
@property NSString* aroundOftempreature;

@property UILabel *mainTempr;
@property UILabel *mainWeather;
@property UILabel *aroundOftemp;
@property UILabel *topCity;

@property NSMutableArray *weeks;
@property NSMutableArray *weektempreture;
@property NSMutableArray *weeksArray;
@property NSMutableData *weekDatas;
@property NSMutableArray *weeksValueArray;
@property NSMutableArray *weeksValue;
@property NSMutableArray *hoursWeather;
@property NSMutableArray *moreINFO;
@property NSMutableArray *airValue;
@property NSMutableArray *lifeValue;

@property NSMutableArray *citys;

@end

