//
//  Events.m
//  SimpleEKDemo
//
//  Created by tzviki fisher on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Events.h"
@interface Events(private)

@end

@implementation Events
@synthesize EventStore=m_eventStore;
@synthesize EventsList=m_eventList;
@synthesize DefaultCalendar=m_defaultCalendar;



-(id)init{
    if ([super init]) {
        // Initialize an event store object with the init method. Initilize the array for events.
        m_eventStore = [[EKEventStore alloc] init];
        [m_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            NSLog(@"granted!");
        }];
        
        
        
        // Get the default calendar from store.
        self.DefaultCalendar = [self.EventStore defaultCalendarForNewEvents];
        //initialize event list with current month and year]
        //[self.DefaultCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:today];
        NSArray *arr = [self fetchEventsForMonth:[comps month] andYear:[comps year]];
        m_eventList = [[NSMutableArray alloc] initWithArray:arr];
        
    }
    return  self;
}
+(Events*)sharedInstance {
    static Events *sharedEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvents = [[self alloc] init];
    });
    return sharedEvents;
}

// Fetching events happening in the next 24 hours with a predicate, limiting to the default calendar 
- (NSArray *)fetchEventsForMonth:(NSInteger)month andYear:(NSInteger)year{
    //NSDate *date = [NSDate date];
    //NSDate *date = [NSDate alloc] init
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    [currentCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:month];
    [comps setYear:year];
    
    NSDate *firstDayDate = [currentCalendar dateFromComponents:comps];
    
    //NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSRange range = [currentCalendar rangeOfUnit:NSDayCalendarUnit
                                          inUnit:NSMonthCalendarUnit
                                         forDate:[currentCalendar dateFromComponents:comps]];
	[comps setDay:range.length];
    NSDate *lastDayDate = [currentCalendar dateFromComponents:comps];
	NSPredicate *predicate = [self.EventStore predicateForEventsWithStartDate:firstDayDate endDate:lastDayDate
                                                                    calendars:nil];
    NSArray *events = [self.EventStore eventsMatchingPredicate:predicate];
    NSMutableArray *overTimeEvents = [[NSMutableArray alloc] init];
    for (EKEvent *event in events) {
        if ([event.title isEqualToString:@"שנ"]) {
            [overTimeEvents addObject:event];
        }
    }
    return overTimeEvents;
}
-(void)dealloc {
    [m_eventStore release];
    [m_defaultCalendar release];
    [m_eventList release];
    [super dealloc];
}
@end
