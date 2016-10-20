//
//  RequestData.m
//  NomalWeather
//
//  Created by 常昊 on 16/10/9.
//  Copyright © 2016年 常昊. All rights reserved.
//

#import "RequestData.h"
@interface RequestData()
{
    
    NSMutableData *receiveData;
    NSArray *resault;
    NSMutableDictionary *location;
    
}
@end
@implementation RequestData
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:@"延安"];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"Pingying: %@", ms); // wǒ shì zhōng guó rén
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"Pingying: %@", ms); // wo shi zhong guo ren
        }
        
        NSString *strUrl = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",strUrl);
        
        
        NSString *urlCat=[NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.today&weaid=%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",strUrl];
        NSURL *url=[NSURL URLWithString:urlCat];
        NSURLRequest *requst=[[NSURLRequest alloc]initWithURL:url];
        NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:requst delegate:self];
        [connection start];

    }
    return self;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  
    id obj=[NSJSONSerialization JSONObjectWithData:_receiveData options:0 error:nil];
//    NSLog(@"%@",obj);
    if([obj isKindOfClass:[NSDictionary class]])
    {
        _location=obj[@"result"];
        NSLog(@"%@",_location);
    }
    [self.delegate needForRequest:@"thisDay" andTheAnwser:_location];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    if (_receiveData==nil) {
        _receiveData=[[NSMutableData alloc]init];
    }
    [_receiveData appendData:data];
    //NSLog(@"%@",data);
}
-(void)connection:(NSConnection*)connection didReceiveResponse:(nonnull NSURLResponse *)responsere
{
    //NSLog(@"%@",responsere);
}

@end
