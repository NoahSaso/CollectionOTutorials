@interface SomeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

static UIImage* selectedImage = nil;

%hook SomeViewController

-(void)viewDidLoad {
	%orig;
	// Add some button
	UIButton* someButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[someButton setImage:someImage forState:UIControlStateNormal];
	[someButton addTarget:self action:@selector(someButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	someButton.frame = someFrame;
	[self.view addSubview:someButton];
}

%new -(void)someButtonPressed {
	someLog(@"Pressed picker button");
	// Create controller
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	// Set to YES to enable editing but it's weird and I don't like it
	// Presents weird sizing issues, idk you can figure this part out
	picker.allowsEditing = NO;
	// Set to UIImagePickerControllerSourceTypeCamera to use camera
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	// Only use if sourceType is set to UIImagePickerControllerSourceTypeCamera
	// For front camera, use UIImagePickerControllerCameraDeviceFront
	//picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;

	// Show view controller
    [self presentViewController:picker animated:YES completion:nil];
}

%new -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	someLog(@"Selected an image");
	// Use copy because this dictionary is released once the view
	// controller is dismissed and the pointer will just point to junk
	selectedImage = [info[UIImagePickerControllerOriginalImage] copy];
	// Dismiss view controller
	[picker dismissViewControllerAnimated:YES completion:nil];
}

%new -(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	someLog(@"Canceled image picker");
	// Dismiss view controller
	[picker dismissViewControllerAnimated:YES completion:nil];
}

%end
