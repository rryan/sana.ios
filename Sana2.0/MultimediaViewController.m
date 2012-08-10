//
//  MultimediaQuestionViewController.m
//  kidsAidMultimedia
//
//  Created by Richard Lu on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultimediaViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>//**Also must add this framework to the project**//
//#import "kidsAidMultimediaAppDelegate.h"
#import "Question.h"
#import "Image.h"
#import "MultimediaTOCViewController.h"

@implementation MultimediaViewController

@synthesize managedObjectContext, fetchedResultsController;
@synthesize procedureRunnerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)viewMultimedia{
    MultimediaTOCViewController *multimediaTOCViewController = [[MultimediaTOCViewController alloc ]initWithNibName:@"MultimediaTOCViewController" bundle:nil];
    multimediaTOCViewController.managedObjectContext = self.managedObjectContext;
    multimediaTOCViewController.fetchedResultsController = self.fetchedResultsController;
    [self.navigationController pushViewController:multimediaTOCViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"KidsAid: Question 10";
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(viewMultimedia)];
    self.navigationItem.rightBarButtonItem = addButtonItem;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)addMultimedia:(id)sender{
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSLog(@"BUTTON:%@",button);
    switch (button.tag) {
        case Audio:
            NSLog(@"AUDIO");
            [self showMultimediaCaptureUI: Audio presentingViewController: self delegate:self];
            break;
        case Video:
            NSLog(@"video");
            [self showMultimediaCaptureUI: Video presentingViewController: self delegate:self];
            break;
        case Photo:
            NSLog(@"photo");
            [self showMultimediaCaptureUI: Photo presentingViewController: self delegate:self];
            break;
        default:
            break;
    }
}


-(BOOL)showMultimediaCaptureUI: (MultimediaType) mmType presentingViewController: (UIViewController *) vc delegate:(id <UIImagePickerControllerDelegate>) theDelegate{
    NSLog(@"showing mm capture UI");
    
    NSLog(@"vc:%@",vc);
    NSLog(@"the delegate:%@",theDelegate);
    
//    if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO)
//        || (theDelegate == nil) || (vc == nil))
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO){
        return NO;

    }

    
    UIImagePickerController *mmUI = [[UIImagePickerController alloc] init];
    mmUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    mmUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];

    switch (mmType) {
        case Audio:
            NSLog(@"showing mm ui");
            break;
        case Video:
            NSLog(@"showing video mm");
            bool videoSupported = NO;
            videoSupported = [mmUI.mediaTypes containsObject: (NSString *) kUTTypeMovie];
            if (videoSupported) {
                mmUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                NSLog(@"mmUI mediatypes:%@",mmUI.mediaTypes);
            }
            else {
                return NO;
            }

            break;
        case Photo:
            NSLog(@"showing camera ui");
            bool cameraSupported = NO;
            cameraSupported = [mmUI.mediaTypes containsObject: (NSString *) kUTTypeImage];
            if (cameraSupported) {
                mmUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                NSLog(@"mmUI mediatypes:%@",mmUI.mediaTypes);
            }
            else {
                return NO;
            }
             
            break;
        default:
            NSLog(@"something went wrong");
            break;
    }
    
    mmUI.allowsEditing =YES;
    mmUI.delegate = theDelegate;
    [self.procedureRunnerViewController presentModalViewController:mmUI animated:YES];
//    [vc presentModalViewController: mmUI animated: YES];
    //[mmUI release];
    return YES;
    
}

#pragma mark - UIImagePickerController Delegate Methods


// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
//    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [self.procedureRunnerViewController dismissModalViewControllerAnimated: YES];
}



// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {

        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

        if (editedImage) { 
            imageToSave = editedImage;
        } 
        else {
            imageToSave = originalImage;
        }

        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil); 
        
        //Save the new image (original or edited) to the database
        [self saveMultimediaToDatabase:imageToSave];
        
    }
  
    // Handle a movie capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
        
        [self saveMultimediaToDatabase:moviePath];

    }
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    
}

-(void)saveMultimediaToDatabase:(id)mm{

    
    Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:managedObjectContext];
    question.date = [NSDate date];

    //store just the path to the image inside core data
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
    
    NSString *imageName = @"img";
    imageName = [imageName stringByAppendingFormat:@"%@",[NSDate date]];
    NSLog(@"imageName:%@",imageName);

    NSString *imagePath = [documentsDirectoryPath stringByAppendingPathComponent:imageName];
    
    //write the path to core data
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:managedObjectContext];
    image.path = imagePath;
    
    //If you for some reason wish to store the actual image inside core data (not recommended)
    //    image.contents = mm;I've already created an NSValueTransformer which will change the image to NSData
    
    if (![UIImageJPEGRepresentation((UIImage *) mm, 1.0) writeToFile:imagePath atomically:YES]){
        NSLog(@"COULD NOT WRITE SUCCESSFULLY");
    }
    else {
        NSLog(@"wrote filename:%@",imagePath);
    }
      
    question.questionToImage = image;
    question.title = imageName;
    
    NSError *error = nil;
    if (![question.managedObjectContext save:&error]){
        NSLog(@"awwww crap could not save");
    }
    else {
        NSLog(@"saved question");
    }
    
    //retrieve the file that we just wrote as a test
    
}


@end
