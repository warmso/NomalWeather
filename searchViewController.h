//
//  searchViewController.h
//  NomalWeather
//
//  Created by 常昊 on 16/10/10.
//  Copyright © 2016年 常昊. All rights reserved.
//

#import "ViewController.h"

@interface searchViewController : ViewController
//@property NSString
@property NSUserDefaults *defaults;
@property NSMutableArray *citys;

@property NSMutableData *cityDatas;
@property NSMutableArray *cityArray;

@property NSMutableArray *realCityName;
@property NSMutableString *cityCNName;
@property NSString *cityname;

@property UIView *background;
@end
