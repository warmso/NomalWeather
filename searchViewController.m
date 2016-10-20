//
//  searchViewController.m
//  NomalWeather
//
//  Created by 常昊 on 16/10/10.
//  Copyright © 2016年 常昊. All rights reserved.
//

#import "searchViewController.h"
#import "ViewController.h"
@interface searchViewController ()
{
    UITextField *searchInput;

}
@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

 
    // Do any additional setup after loading the view.
    //self.view.alpha=0;
    _cityname=[[NSString alloc]init];
    
    CGRect frame=[UIScreen mainScreen].bounds;
    UIView *top=[[UIView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width, 76)];
    [top setBackgroundColor:[UIColor grayColor]];

    searchInput=[[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/2-150, 30, 250, 35)];
    [searchInput setBackgroundColor:[UIColor whiteColor]];
    [top addSubview:searchInput];
    
    UIButton *backTo=[UIButton buttonWithType:UIButtonTypeCustom];
    [backTo setFrame:CGRectMake(20, 30, 30, 35)];
    [backTo setBackgroundColor:[UIColor whiteColor]];
    [backTo addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [top addSubview:backTo];
    
    UIButton *findTheCity=[UIButton buttonWithType:UIButtonTypeCustom];
    [findTheCity setFrame:CGRectMake(frame.size.width/2+110, 30, 80, 35)];
    [findTheCity setBackgroundColor:[UIColor whiteColor]];
    [findTheCity addTarget:self action:@selector(findTheCity) forControlEvents:UIControlEventTouchUpInside];
    [top addSubview:findTheCity];
    
    
    
    UIView *background=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [background setBackgroundColor:[UIColor whiteColor]];
    _background=background;
    
    [self.view addSubview:background];
    [self.view addSubview:top];
    [searchInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reKeyBoard)];
    [self.view addGestureRecognizer:tap];
    

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"citys"];
    _citys = [NSMutableArray arrayWithArray:[defaults objectForKey:@"citys"]];
    
    
    
    NSInteger numOfCity=_citys.count;
    for (NSInteger i=0; i<numOfCity; i++) {
        UILabel *cityItem=[[UILabel alloc]initWithFrame:CGRectMake(20, 76*2+i*80, frame.size.width-40, 70)];
        [cityItem setTextColor:[UIColor whiteColor]];
        [cityItem setText:_citys[i]];
        [cityItem setBackgroundColor:[UIColor grayColor]];
        [background addSubview:cityItem];
    }
    
    
    
    
    
    
}

-(void)findTheCity
{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:_cityname];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"Pingying: %@", ms);
    }
    
    NSString *strUrl = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",strUrl);
    
    
    NSString *urlCat=[NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.today&weaid=%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",strUrl];
    NSURL *url=[NSURL URLWithString:urlCat];
    NSURLRequest *requst=[[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:requst delegate:self];
    [connection start];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    NSMutableString *temp=[[NSMutableString alloc]initWithString:theTextField.text];
    [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (temp.length>=3)
    for (NSInteger i=0; i<temp.length-1; i++) {
        if ([temp characterAtIndex:i]>'z'||[temp characterAtIndex:i]<'a') {
            [temp deleteCharactersInRange:NSMakeRange(i, 1)];
            
        }
    }
    if (temp.length&&[temp characterAtIndex:0]<='z'&&[temp characterAtIndex:0]>='a'&&temp.length>=2)
        _cityname=temp;
        NSLog(@"%@",_cityname);
    
}

- (void)reKeyBoard
{
    [searchInput resignFirstResponder];
    
}
-(void)back
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSLog(@"----%@",_citys);
    [defaults setObject:_citys forKey:@"citys"];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"the end of city");
    
    id obj=[NSJSONSerialization JSONObjectWithData:_cityDatas options:0 error:nil];
    if([obj isKindOfClass:[NSDictionary class]])
    {
       _cityArray=obj[@"result"];
        
        NSLog(@"%@",_cityArray);//////////////////////////find successful
        if (_cityArray) {
            NSLog(@"search successful");
            UILabel *cityItem=[[UILabel alloc]initWithFrame:CGRectMake(20, 76*2+(_citys.count)*80, [UIScreen mainScreen].bounds.size.width-40, 70)];
            [cityItem setBackgroundColor:[UIColor grayColor]];
            [cityItem setTextColor:[UIColor whiteColor]];
            [cityItem setText:_cityname];
            [_background addSubview:cityItem];
            [_citys addObject:_cityname];
            [self.view reloadInputViews];
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    if (_cityDatas==nil) {
        _cityDatas=[[NSMutableData alloc]init];
    }
    [_cityDatas appendData:data];
//    NSLog(@"%@",_cityDatas);
    
}

@end
