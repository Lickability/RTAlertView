//
//  RTAlertViewRecursiveButtonContainerView.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/13/2013.
//  Copyright (c) 2013 MoozX Internet Ventures. All rights reserved.
//


#import "RTAlertViewRecursiveButtonContainerView.h"


static CGFloat kButton2EnabledWidth = 135.0f;
static CGFloat kButton2DisabledWidth = 0.0f;
static CGFloat kDividerThicknessRetina = 0.5f;
static CGFloat kDividerThicknessNonRetina = 1.0f;

#define kRtAlertViewDefaultButtonColor [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewDefaultButtonFont  [UIFont systemFontOfSize:17.0f]


@interface RTAlertViewRecursiveButtonContainerView ()

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIView *horizontalDividerLine;
@property (weak, nonatomic) IBOutlet UIView *verticalDividerLine;
@property (weak, nonatomic) IBOutlet UIView *nextButtonContainer;

@property (nonatomic) BOOL button2EnabledFlagHasChanged;
@property (nonatomic) BOOL displayIsRetina;

@end


@implementation RTAlertViewRecursiveButtonContainerView


#pragma mark - Initialisers and dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // Load XIB
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"RTAlertViewRecursiveButtonContainerView"
                                                          owner:self
                                                        options:nil];

        for (id xibObject in xibArray)
        {
            // Find object in XIB
            if ([xibObject isKindOfClass:[RTAlertViewRecursiveButtonContainerView class]])
            {
                self = xibObject;
            }
        }
    }
    
    return self;
}


- (void)initialiseProperties
{
    _button2Enabled = NO;
    _button2EnabledFlagHasChanged = NO;
    
    // Check for retina?
    CGFloat dividerThickness;
    if (self.displayIsRetina == YES)
    {
        // Retina
        dividerThickness = kDividerThicknessRetina;
    }
    else
    {
        // Non-retina
        dividerThickness = kDividerThicknessNonRetina;
    }
    
    // Set constraint for vertical divider height
    NSLayoutConstraint *hDividerHeight = [NSLayoutConstraint constraintWithItem:self.horizontalDividerLine
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:dividerThickness];
    [self.horizontalDividerLine addConstraint:hDividerHeight];

    // Set constraint for vertical divider height
    NSLayoutConstraint *vDividerWidth = [NSLayoutConstraint constraintWithItem:self.verticalDividerLine
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:dividerThickness];
    [self.verticalDividerLine addConstraint:vDividerWidth];
    
    // Set default button colours and fonts
    self.button0Color = kRtAlertViewDefaultButtonColor;
    self.button0Font = kRtAlertViewDefaultButtonFont;
    self.button1Color = kRtAlertViewDefaultButtonColor;
    self.button1Font = kRtAlertViewDefaultButtonFont;
    
    
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"In RTAlertViewRecursiveButtonContainerView awakeFromNib");
    NSLog(@"self frame: %@", NSStringFromCGRect(self.frame));
    [self initialiseProperties];
}


- (void)dealloc
{
    NSLog(@"In RTAlertViewRecursiveButtonContainerView dealloc");
}


#pragma mark - Setter methods

- (void)setButton2Enabled:(BOOL)button2Enabled
{
    if (button2Enabled != _button2Enabled)
    {
        _button2Enabled = button2Enabled;
        _button2EnabledFlagHasChanged = YES;
    }
}


- (void)setButton0Color:(UIColor *)button1Color
{
    [self.button0 setTitleColor:button1Color
                       forState:UIControlStateNormal];
    [self.button0 setBackgroundImage:[self imageFromColor:[button1Color colorWithAlphaComponent:0.1f]]
                            forState:UIControlStateHighlighted];
}


- (void)setButton1Color:(UIColor *)button2Color
{
    [self.button1 setTitleColor:button2Color
                       forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[self imageFromColor:[button2Color colorWithAlphaComponent:0.1f]]
                            forState:UIControlStateHighlighted];
}


- (void)setButton0Font:(UIFont *)button1Font
{
    self.button0.titleLabel.font = button1Font;
}


- (void)setButton1Font:(UIFont *)button2Font
{
    self.button1.titleLabel.font = button2Font;
}


#pragma mark - Getter methods

- (BOOL)displayIsRetina
{
    if ([UIScreen mainScreen].scale >= 2.0f)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark - Public methods

- (void)addRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)nextRecursiveButtonContainerView
{
    [self.nextButtonContainer addSubview:nextRecursiveButtonContainerView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(nextRecursiveButtonContainerView);
    
    [self.nextButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nextRecursiveButtonContainerView]|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:views]];
    [self.nextButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nextRecursiveButtonContainerView]|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:views]];
}


#pragma mark - Layout methods

- (void)updateConstraints
{
    // Has button2Enabled flag changed?
    if (self.button2EnabledFlagHasChanged == YES)
    {
        // Clear flag
        self.button2EnabledFlagHasChanged = NO;

        // Clear button2 constraints, width should be the only existing constraint
        NSArray *button2Constraints = self.button1.constraints;
        [self.button1 removeConstraints:button2Constraints];

        // Enabling or disabling?
        CGFloat button2Width;
        if (self.button2Enabled == YES)
        {
            // Enabling, show button2 and vertical divider
            self.button1.hidden = NO;
            self.verticalDividerLine.hidden = NO;

            // Set button2 width
            button2Width = kButton2EnabledWidth;
        }
        else
        {
            // Disabling, hide button2 and vertical divider
            self.button1.hidden = YES;
            self.verticalDividerLine.hidden = YES;

            // Set button2 width
            button2Width = kButton2DisabledWidth;
        }

        // Set constraint for button2 width
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.button1
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:button2Width];
        [self.button1 addConstraint:newConstraint];
    }
    
    // Call super after we're done
    [super updateConstraints];
}

/*
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"Button 1, frame=%@", NSStringFromCGRect(self.button1.frame));
    NSLog(@"Button 2, frame=%@", NSStringFromCGRect(self.button2.frame));
    NSLog(@"Horizontal divider line, frame=%@", NSStringFromCGRect(self.horizontalDividerLine.frame));
    NSLog(@"Vertical divider line, frame=%@", NSStringFromCGRect(self.verticalDividerLine.frame));
    NSLog(@"Next button container, frame=%@", NSStringFromCGRect(self.nextButtonContainer.frame));
}
*/

#pragma mark - IBAction methods

- (IBAction)button1Tapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rtAlertViewRecursiveButtonContainerView:tappedButtonNumber:)] == YES)
    {
        [self.delegate rtAlertViewRecursiveButtonContainerView:self
                                            tappedButtonNumber:0];
    }
}


- (IBAction)button2Tapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rtAlertViewRecursiveButtonContainerView:tappedButtonNumber:)] == YES)
    {
        [self.delegate rtAlertViewRecursiveButtonContainerView:self
                                            tappedButtonNumber:1];
    }
}


#pragma mark - Private methods

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,
                             0.0f,
                             1.0f,
                             1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}


@end
