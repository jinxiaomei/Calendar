//
//  ViewController.m
//  CalendarDemo
//
//  Created by pengli on 16/4/13.
//  Copyright © 2016年 jinxiaomei. All rights reserved.
//

#import "ViewController.h"
#import "FSCalendar.h"
@interface ViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 400;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), view.bounds.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.allowsMultipleSelection = YES;
    [self.view addSubview:calendar];
    self.calendar = calendar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"testData"];
    NSMutableArray * dataSource = [[NSMutableArray alloc] initWithArray:arr];
    
    for (int i = 0; i < dataSource.count; i++)
    {
        NSDate * date = [dateFormatter dateFromString:[[dataSource objectAtIndex:i] objectForKey:@"date"]];
        [_calendar selectDate:date];
    }
    
#if 0
    FSCalendarTestSelectDate
#endif
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    BOOL shouldDedeselect = [_calendar dayOfDate:date] != 5;
    if (!shouldDedeselect) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Forbidden date %@ to be selected",[calendar stringFromDate:date]] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date
{
    BOOL shouldDedeselect = [_calendar dayOfDate:date] != 7;
    if (!shouldDedeselect) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Forbidden date %@ to be deselected",[calendar stringFromDate:date]] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    //    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    //    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        [selectedDates addObject:[calendar stringFromDate:obj format:@"yyyy/MM/dd"]];
    //    }];
    //    NSLog(@"selected dates is %@",selectedDates);
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date
{
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[calendar stringFromDate:obj format:@"yyyy/MM/dd"]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date
{
    return appearance.selectionColor;
    
    
    if ([_calendar dayOfDate:date] % 2 == 0) {
        return appearance.selectionColor;
    }
    return [UIColor purpleColor];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    if ([@[] containsObject:@([calendar dayOfDate:date])]) {
        return [UIColor magentaColor];
    }
    return [UIColor lightGrayColor];
    return appearance.borderDefaultColor;
}
@end
