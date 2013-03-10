//
//  Events.h
//  SimpleEKDemo
//
//  Created by tzviki fisher on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#define EventsSharedInstance [Events sharedInstance]

@interface Events : NSObject {
    @private
    EKEventStore *m_eventStore;
    NSMutableArray *m_eventsList;
    EKCalendar *m_defaultCalendar;
}
    
@property (nonatomic, retain) EKEventStore *EventStore;
@property (nonatomic, retain) EKCalendar *DefaultCalendar;
@property (nonatomic, readonly) NSMutableArray *EventsList;
+(Events*)sharedInstance;
- (NSArray *) fetchEventsForMonth:(NSInteger)month andYear:(NSInteger)year;

@end
