//
//  ViewController.m
//  NomalWeather
//
//  Created by 常昊 on 16/10/7.
//  Copyright © 2016年 常昊. All rights reserved.
//

#import "ViewController.h"
#import "RequestData.h"
#import "searchViewController.h"

@interface ViewController ()<requestDataDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)RequestData *requstData;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"citys"];
    _citys = [NSMutableArray arrayWithArray:[defaults objectForKey:@"citys"]];
    
    
    NSString *oriCity=@"延安";
    if (CFStringTransform((__bridge CFMutableStringRef)oriCity, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"Pingying::::: %@", oriCity); // wo shi zhong guo ren
    }
    
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.future&weaid=%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",oriCity]];
    NSURLRequest *requst=[[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:requst delegate:self];
    [connection start];
    
    //requaset
    _nameOfTopCity=@"- -";
    _tempr=@"-";
    _theWeather=@"- -";
    self.requstData = [[RequestData alloc]init];
    self.requstData.delegate = self;
    
    CGRect frame=[UIScreen mainScreen].bounds;
    UIView *top=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 76)];
    [top setBackgroundColor:[UIColor grayColor]];
    _topCity=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-75, 30, 150, 30)];
    _topCity.textAlignment=UITextAlignmentCenter;
    [_topCity setText:_nameOfTopCity];
    [_topCity setFont:[UIFont systemFontOfSize:26]];
    [_topCity setTextColor:[UIColor whiteColor]];
    
    UIButton *addBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [addBut setFrame:CGRectMake(370, 30, 30, 35)];
    [addBut setBackgroundColor:[UIColor whiteColor]];
    [addBut addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [top addSubview:addBut];
    [top addSubview:_topCity];
    [self.view addSubview:top];
    
    UIScrollView *moreThanOne=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 76,frame.size.width , frame.size.height-76)];
    moreThanOne.contentSize=CGSizeMake(2*frame.size.width, frame.size.height-76) ;
    moreThanOne.pagingEnabled = YES;
    moreThanOne.showsHorizontalScrollIndicator=NO;
    moreThanOne.delegate=self;
    [self.view addSubview:moreThanOne];

    UIScrollView *mainView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-76)];
    [mainView setContentSize:CGSizeMake(frame.size.width, frame.size.height+592+460)];
    [mainView setBackgroundColor:[UIColor blackColor]];
    mainView.showsHorizontalScrollIndicator=NO;
    [moreThanOne addSubview: mainView];
    
    
    _mainTempr=[[UILabel alloc]initWithFrame:CGRectMake(90, 98, 200, 90)];
    [_mainTempr
     setTextColor:[UIColor whiteColor]];
    [_mainTempr setFont:[UIFont systemFontOfSize:80]];
    [_mainTempr setText:_tempr];
    [_mainTempr setTextAlignment:UITextAlignmentCenter];
    [mainView addSubview: _mainTempr];
    
    _mainWeather=[[UILabel alloc]initWithFrame:CGRectMake(250, 140, 80, 28)];
    [_mainWeather setTextColor:[UIColor whiteColor]];
    [_mainWeather setText:_theWeather];
    _mainWeather.textAlignment=UITextAlignmentCenter;
    [mainView addSubview:_mainWeather];
    
    _aroundOftemp=[[UILabel alloc]initWithFrame:CGRectMake(250, 168, 80, 20)];
    [_aroundOftemp setText:_aroundOftempreature];
    [_aroundOftemp setTextColor:[UIColor whiteColor]];
    _aroundOftemp.textAlignment=UITextAlignmentCenter;
    [mainView addSubview:_aroundOftemp];
    
    UIScrollView *hours=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 350, frame.size.width, 120)];
    hours.showsHorizontalScrollIndicator=NO;
    [hours setContentSize:CGSizeMake(frame.size.width*4, 120)];
    [hours setBackgroundColor:[UIColor whiteColor]];
    [mainView addSubview:hours];
    
    _hoursWeather=[[NSMutableArray alloc]init];
    
    for (NSInteger i=0; i<24; i++) {
        UILabel *temp=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/6*i, 15, frame.size.width/6, 36)];
        [temp setText:[NSString stringWithFormat:@"%ld:00",(long)i]];
        [temp setTextAlignment:NSTextAlignmentCenter];
        UILabel *tmp=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/6*i, 55, frame.size.width/6, 36)];
        [tmp setText:@"----"];
        [tmp setTextAlignment:NSTextAlignmentCenter];
        [temp setTextColor:[UIColor blackColor]];
        [tmp setTextColor:[UIColor blackColor]];
        [_hoursWeather addObject:tmp];
        [hours addSubview:temp];
        [hours addSubview:tmp];
        
    }
    _weeks=[[NSMutableArray alloc]init];
    _weeksValue=[[NSMutableArray alloc]init];
    _weektempreture=[[NSMutableArray alloc]init];
    UIScrollView *weeksDays=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 470, frame.size.width, 154)];
    weeksDays.showsHorizontalScrollIndicator=NO;
    [weeksDays setBackgroundColor:[UIColor whiteColor]];
    [weeksDays setContentSize:CGSizeMake(frame.size.width/4*7, 154)];
    [mainView addSubview: weeksDays];
    
    for (NSInteger i=0; i<7; i++) {
        UILabel *temp=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/4*i, 15, frame.size.width/4, 36)];
        [temp setTextAlignment:NSTextAlignmentCenter];
        [temp setTextColor:[UIColor blackColor]];
        [temp setText:@"---"];
        
        UILabel *tmp=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/4*i, 55, frame.size.width/4, 36)];
        [tmp setTextColor:[UIColor blackColor]];
        [tmp setTextAlignment:NSTextAlignmentCenter];
        [tmp setText:@"----"];
        
        UILabel *ttmp=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/4*i, 96, frame.size.width/4, 36)];
        [ttmp setTextColor:[UIColor blackColor]];
        [ttmp setTextAlignment:NSTextAlignmentCenter];
        [ttmp setText:@"----"];
        
        [weeksDays addSubview:ttmp];
        [weeksDays addSubview:temp];
        [weeksDays addSubview:tmp];
        [_weektempreture addObject:ttmp];
        [_weeks addObject:temp];
        [_weeksValue addObject:tmp];
        
    }
    
    UIView *moreInfomatation=[[UIView alloc]initWithFrame:CGRectMake(0,50+frame.size.height, frame.size.width, 156)];
    [moreInfomatation setBackgroundColor:[UIColor grayColor]];
    [mainView addSubview:moreInfomatation];
    
    UILabel *today=[[UILabel alloc]initWithFrame:CGRectMake(186, 0, 70, 39)];
    UILabel *bodyTemp=[[UILabel alloc]initWithFrame:CGRectMake(186, 39, 70, 39)];
    UILabel *airTemp=[[UILabel alloc]initWithFrame:CGRectMake(186, 39*2, 70, 39)];
    UILabel *wind=[[UILabel alloc]initWithFrame:CGRectMake(186, 39*3, 70, 39)];
    
    [today setText:@"体感温度"];
    [bodyTemp setText:@"今日预报"];
    [airTemp setText:@"风向风力"];
    [wind setText:@"空气湿度"];
    
    [today setTextColor:[UIColor whiteColor]];
    [bodyTemp setTextColor:[UIColor whiteColor]];
    [airTemp setTextColor:[UIColor whiteColor]];
    [wind setTextColor:[UIColor whiteColor]];
    
    [moreInfomatation addSubview:today];
    [moreInfomatation addSubview:bodyTemp];
    [moreInfomatation addSubview:airTemp];
    [moreInfomatation addSubview:wind];
    
    _moreINFO=[[NSMutableArray alloc]init];
    
    for (NSInteger i=0; i<4; i++) {
        UILabel *temp=[[UILabel alloc]initWithFrame:CGRectMake(320, i*39, 70, 39)];
        [temp setTextColor:[UIColor whiteColor]];
        [temp setTextAlignment:NSTextAlignmentCenter];
        [temp setText:@"----"];
        [temp setFont:[UIFont systemFontOfSize:16]];
        [moreInfomatation addSubview:temp];
        [_moreINFO addObject:temp];
    }
    
    UIView *airCondition=[[UIView alloc]initWithFrame:CGRectMake(0, 270+frame.size.height, frame.size.width, 260)];
    [airCondition setBackgroundColor:[UIColor grayColor]];
    [mainView addSubview:airCondition];
    
    UIView *theWatch=[[UIView alloc]init];
    [theWatch setBackgroundColor:[UIColor whiteColor]];
    [theWatch setFrame:CGRectMake(20, 50, (frame.size.width-40)/7*5, 25)];
    [airCondition addSubview:theWatch];
    
    for (NSInteger i=0; i<6; i++) {
        UILabel *temp=[[UILabel alloc]initWithFrame:CGRectMake((i%3)*frame.size.width/3+20, 126+(i/3)*68, frame.size.width/3, 68)];
        [temp setText:@"123"];
        [temp setTextColor:[UIColor whiteColor]];
        [airCondition addSubview:temp];
        UILabel *tmp=[[UILabel alloc]initWithFrame:CGRectMake((i%3)*frame.size.width/3+70, 126+(i/3)*68, frame.size.width/3, 68)];
        [tmp setTextColor:[UIColor whiteColor]];
        [tmp setText:@"456"];
        [airCondition addSubview:tmp];
        [_airValue addObject:tmp];
    }
    
    UIView *lifeCondition=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height+592, frame.size.width, 460)];
    [lifeCondition setBackgroundColor:[UIColor grayColor]];
    for (NSInteger i=0; i<5; i++) {
        UILabel *temp=[[UILabel alloc]initWithFrame:CGRectMake(312, lifeCondition.bounds.size.height/5*i+24, 90, 24)];
        [temp setBackgroundColor:[UIColor whiteColor]];
        [temp setText:@"1234"];
        [lifeCondition addSubview:temp];
        UILabel *tmp=[[UILabel alloc]initWithFrame:CGRectMake(110, lifeCondition.bounds.size.height/5*i+24, 66, 30)];
        [tmp setTextColor:[UIColor whiteColor]];
        [tmp setText:@"4566"];
        [_lifeValue addObject:tmp];
        [lifeCondition addSubview:tmp];
        [mainView addSubview:lifeCondition];
    }
    
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *name =@”default string“;
//    [defaults setObject:firstName forKey:@"name"];
//    //获得UIImage实例
//    
//    UIImage *image=[[UIImage alloc]initWithContentsOfFile:@"photo.jpg"];
//    
//    NSData *imageData = UIImageJPEGRepresentation(image, 100);//UIImage对象转换成NSData
//    
//    [defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据库
    
}



-(void)needForRequest:(NSString *)requestWords andTheAnwser:(NSMutableDictionary *)dic{
    
    
    _nameOfTopCity=[dic objectForKey:@"citynm"];
    [_nameOfTopCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_topCity setText:_nameOfTopCity];
    
    
    _tempr=[dic objectForKey:@"temperature_curr"];
    [_tempr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_mainTempr setText:_tempr];
NSLog(@"~~~~~~~~~~~%@",_tempr);
    
    _theWeather=[dic objectForKey:@"weather_curr"];
    [_theWeather stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_mainWeather setText:_theWeather];
    
   
    [_moreINFO[0] setText:[dic objectForKey:@"temperature"]];
    [_moreINFO[1] setText:[dic objectForKey:@"weather"]];
    [_moreINFO[2] setText:[dic objectForKey:@"winp"]];
    [_moreINFO[3] setText:[dic objectForKey:@"humidity"]];
    

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"the end");
    id obj=[NSJSONSerialization JSONObjectWithData:_weekDatas options:0 error:nil];
    NSLog(@"%@",obj);
    if([obj isKindOfClass:[NSDictionary class]])
    {
        _weeksArray=obj[@"result"];
        NSLog(@"%@",_weeksArray);
        _weeksValueArray=_weeksArray[0];
        NSLog(@"----***--%@",_weeksValueArray);
    }
    for(NSInteger i=0  ;i<7;i++)
    {
        _weeksValueArray=_weeksArray[i];
        NSString *temp=[(NSDictionary *)_weeksValueArray objectForKey:@"week"];
        [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_weeks[i] setText:temp];
        
        temp=[(NSDictionary *)_weeksValueArray objectForKey:@"weather"];
        [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_weeksValue[i] setText:temp];
        
        temp=[(NSDictionary *)_weeksValueArray objectForKey:@"temperature"];
        [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_weektempreture[i] setText:temp];
        NSLog(@"%@",temp);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    if (_weekDatas==nil) {
        _weekDatas=[[NSMutableData alloc]init];
    }
    [_weekDatas appendData:data];
    //NSLog(@"%@",data);
    
}

-(void)click:(UIButton *)sender
{
    
    searchViewController *newViewController=[[searchViewController alloc]init];
    [self.navigationController pushViewController:newViewController animated:true];
    NSLog(@"%@",self.navigationController);
    


}

@end
