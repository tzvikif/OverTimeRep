//
//  ListViewController.h
//  SimpleEKDemo
//
//  Created by Tzviki Fisher on 8/22/12.
//  Copyright (c) 2012 Leumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface ListViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, 
EKEventEditViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
	EKEventViewController *detailViewController;
    UILabel *m_overTimeSummary;
    UITableView *m_table;
}

//@property (nonatomic, retain) EKEventStore *eventStore;
//@property (nonatomic, retain) EKCalendar *defaultCalendar;
//@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UILabel  *overTimeSummary;
@property (nonatomic, retain) IBOutlet UITableView *Table;

- (NSArray *) fetchEventsForMonth:(NSInteger)month andYear:(NSInteger)year;
-(void) addEvent:(id)sender;
-(UIColor*)colorForIndex:(NSInteger) index;

@end
