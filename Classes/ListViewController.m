
#import "ListViewController.h"
#import "CustomCell.h"
#import "Events.h"

@interface ListViewController()
- (NSString*)calcSumm;
@end
@implementation ListViewController


//@synthesize eventsList, eventStore, defaultCalendar, 
@synthesize detailViewController;
@synthesize overTimeSummary=m_overTimeSummary;
@synthesize Table=m_table;
#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[detailViewController release];
    [m_overTimeSummary release];
    [m_table release];
    
	[super dealloc];
}
- (NSString*)calcSumm
{
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSArray *eventsList = [[Events sharedInstance] EventsList];
    for (EKEvent *event in eventsList) {
        NSDate *startDate = event.startDate;
        NSDate *endDate = event.endDate;
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        
        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:startDate
                                                      toDate:endDate options:0];
        hours += [components hour];
        minutes += [components minute];
    }
    hours = hours + minutes / 60;
    minutes = minutes % 60;
    NSString *summ = [NSString stringWithFormat:@"%d:%d",hours,minutes];
    return  summ;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* anImage = [UIImage imageNamed:@"tab1.png"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"רשימה" image:anImage tag:0];
        self.tabBarItem = theItem;
        [theItem release];

    }
    return self;
}
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"שעות נוספות";
	// Initialize an event store object with the init method. Initilize the array for events.
		
	//	Create an Add button 
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
	self.navigationItem.rightBarButtonItem = addButtonItem;
	[addButtonItem release];
	
	
	self.navigationController.delegate = self;
	
	// Fetch today's event on selected calendar and put them into the eventsList array
    NSDate *now = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
    [EventsSharedInstance.EventsList addObjectsFromArray:[EventsSharedInstance fetchEventsForMonth:[comp month] andYear:[comp year]]];
    self.Table.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.Table reloadData];
    [self addEvent:nil];
	
}


- (void)viewDidUnload {
}


- (void)viewWillAppear:(BOOL)animated {
	[self.Table deselectRowAtIndexPath:self.Table.indexPathForSelectedRow animated:NO];	
    [m_overTimeSummary setText:[self calcSumm]];
}


// Support all orientations except for Portrait Upside-down.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//return (interfaceOrientation != UIInterfaceOrientationPortrait);
    return NO;
}


#pragma mark -
#pragma mark Table view data source

#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows:%d",EventsSharedInstance.EventsList.count);
    return EventsSharedInstance.EventsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"customCellId";
	
	// Add disclosure triangle to cell
	//UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
	
	MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	// Get the event at the row selected and display it's title
    NSDate *startDate = [[EventsSharedInstance.EventsList objectAtIndex:indexPath.row] startDate];
    NSDate *endDate = [[EventsSharedInstance.EventsList objectAtIndex:indexPath.row] endDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *strDate = [formatter stringFromDate:startDate];
    [formatter setDateFormat:@"HH:mm"];
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *strStartTime = [formatter stringFromDate:startDate];
    NSString *strEndTime = [formatter stringFromDate:endDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    //[components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	cell.Date.text = strDate;
    cell.FromHour.text = strStartTime;
    cell.ToHour.text = strEndTime;
    cell.Total.text = [NSString stringWithFormat:@"%d:%d",[components hour],[components minute]];
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Upon selecting an event, create an EKEventViewController to display the event.
	self.detailViewController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];			
	detailViewController.event = [EventsSharedInstance.EventsList objectAtIndex:indexPath.row];
	
	// Allow event editing.
	detailViewController.allowsEditing = YES;
	
	//	Push detailViewController onto the navigation controller stack
	//	If the underlying event gets deleted, detailViewController will remove itself from
	//	the stack and clear its event property.
	[self.navigationController pushViewController:detailViewController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 50.0;
    return 60.0;
}

#pragma mark -
#pragma mark Navigation Controller delegate

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// if we are navigating back to the rootViewController, and the detailViewController's event
	// has been deleted -  will title being NULL, then remove the events from the eventsList
	// and reload the table view. This takes care of reloading the table view after adding an event too.
	if (viewController == self && self.detailViewController.event.title == NULL) {
		[EventsSharedInstance.EventsList removeObject:self.detailViewController.event];
		[self.Table reloadData];
	}
}


#pragma mark -
#pragma mark Add a new event

// If event is nil, a new event is created and added to the specified event store. New events are 
// added to the default calendar. An exception is raised if set to an event that is not in the 
// specified event store.
- (void)addEvent:(id)sender {
    EKEvent *newEvent = [EKEvent eventWithEventStore:EventsSharedInstance.EventStore];
    newEvent.title = @"שנ";
    newEvent.notes = @"מרבה נכסים מרבה דאגה";
	// When add button is pushed, create an EKEventEditViewController to display the event.
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	// set the addController's event store to the current event store.
	addController.eventStore = EventsSharedInstance.EventStore;
    addController.editViewDelegate = self;
    addController.event = newEvent;
	
	// present EventsAddViewController as a modal view controller
	[self presentViewController:addController animated:YES completion:^(void){NSLog(@"completion");}];
	
	
	[addController release];
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// eventsList.
			if (EventsSharedInstance.DefaultCalendar ==  thisEvent.calendar) {
				[EventsSharedInstance.EventsList addObject:thisEvent];
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			[self.Table reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its 
			// eventsList.
			if (EventsSharedInstance.DefaultCalendar ==  thisEvent.calendar) {
				[EventsSharedInstance.EventsList removeObject:thisEvent];
			}
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			[self.Table reloadData];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissViewControllerAnimated:YES completion:NULL];
	
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = EventsSharedInstance.DefaultCalendar;
	return calendarForEdit;
}
-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = [EventsSharedInstance.EventsList count] - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

@end