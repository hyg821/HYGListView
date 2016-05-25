//
//  ViewController.m
//  HYGListView
//
//  Created by 侯英格 on 16/5/24.
//  Copyright © 2016年 侯英格. All rights reserved.
//

#import "ViewController.h"
#import "HYGListView.h"
@interface ViewController ()
@property(nonatomic,strong)HYGListView*listView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray*array=[NSMutableArray array];
    for (int i=0; i<30; i++) {
        int c=0;
        if (i%2==0) {
            c=100;
        }else{
            c=75;
        }
        
        UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, c)];
        view.backgroundColor=[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        UILabel*lab=[[UILabel alloc] initWithFrame:view.bounds];
        lab.font=[UIFont systemFontOfSize:30];
        lab.text=[NSString stringWithFormat:@"%d",i];
        lab.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lab];
        [array addObject:view];
    }
    self.listView=[[HYGListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.listView setViewArray:array andAnimation:YES];
    [self.view addSubview:self.listView];
}

- (IBAction)add:(id)sender {
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    view.backgroundColor=[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    [self.listView addView:view WithRow:3 andAnimation:YES];
}

- (IBAction)delete:(id)sender {
    [self.listView deleteRow:5];
}
- (IBAction)changge:(id)sender {
    UIView*view=[self.listView.viewArray firstObject];
    view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    [self.listView reloadSizeWithAnimation:YES];
}

- (IBAction)scrolltorow:(id)sender {
    [self.listView scrollToRow:15];
}


- (IBAction)hiderow:(id)sender {
    [self.listView hidenRow:3];
}
- (IBAction)showRow:(id)sender {
    [self.listView showRow:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
