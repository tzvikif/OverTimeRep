//
//  CustomCell.h
//  SimpleEKDemo
//
//  Created by Tzviki Fisher on 9/11/12.
//  Copyright (c) 2012 Leumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell {
    UILabel *m_date;
    UILabel *m_fromHour;
    UILabel *m_toHour;
    UILabel *m_total;
    CAGradientLayer* _gradientLayer; 
}
@property(nonatomic,retain) IBOutlet UILabel *Date;
@property(nonatomic,retain) IBOutlet UILabel *FromHour;
@property(nonatomic,retain) IBOutlet UILabel *ToHour;
@property(nonatomic,retain) IBOutlet UILabel *Total;
@end
