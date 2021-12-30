library string_constants;

const String partName = 'partname';
const String partDescription = 'partdescription';
const String partNumber = 'partnumber';
const String storeId = 'storeid';
const String storeLocation = 'storelocation';
const String addedBy = 'addedby';
const String addedById = 'addedbyid';
const String dateAdded = 'dateadded';
const String lastEditedBy = 'lasteditedby';
const String section = 'section';
const String brand = 'brand';
const String likesCount = 'likescount';
const String isExhausted = 'isexhausted';
const String markExhaustedTime = 'markexhaustedtime';
const String searchKeywords = 'searchkeywords';
const String photo = 'photo';
const String markedBadByUid = 'markedbadbyuid';
const String reasonFormarkingBad = 'reasonformarkingbad';
const String partsCollection = 'parts';
const String userCollection = 'users';

const String dialogTitleAddPart = 'Uncompleted Form';
const String dialogBodyAddPart =
    'You were previously editing a part on this device.\nDo you want to continue from where you left off?';
const String yes = 'Yes';
const String no = 'No';

const String userName = 'username';
const String deviceId = 'deviceid';
const String email = 'email';
const String userId = 'userid';
const String partsAddedCount = 'partsAddedCount';
const String accessLevel = 'accesslevel';

const String partNameInfo =
    'This field should contain generic name for the part you are about to add or edit';
const String partNameTitle = 'PartName';
const String partDescriptionTitle = 'Part Description';
const String partDescriptionInfo =
    'In your own words List the features you know about this part such as size, dimension, type, class, place of use, material. Eg: M8 stainless steel bolt with countersunk head for conveyor bottle guide';
const String partNumberTitle = 'Part Number';
const String partNumberInfo =
    'Part identification number that can be used to identify the part, it is usually written on the part. You can write more than one, seperated with space';
const String storeIdTitle = 'Store Id';
const String storeIdInfo =
    'This will enable us locate the item in the sparepart store';
const String brandTitle = 'Brand';
const String brandInfo = 'State the Item brand if avaialble';
const String storeLocationTitle = 'Item Location';
const String storeLocationInfo =
    'State the Shelf Number where it is stored if you know it';
const String sectionTitle = 'Section';

const String isMachineSpecific =
    'Indicate the department where it is commonly used. e.g Cable ties are used by Electrial Department';

const String completeYourProfile =
    'Complete your Profile, so that we can tell who you are';
const String emailVerificationMessage =
    'Your Email is not Yet verified \nClick Here to send Email Verification';
const String emailVerificationSentMessage =
    'Click here to contiue.\n Your Email Verifcation has been sent to:\n';
const String errorLoadingProfile =
    'System Failed Loading your profile! check network connection and retry';
const String noPermisionBody =
    'In order to control App content, Admin Permision is required.\nThis app will be closed\ncontact Admin for support!';
const String noPermisionTitle = 'No Admin Permission !';
const String deviceChanged =
    'Your Device Id has changed. Ensure you are not abusing this app.';

const String aboutApp =
    '''StorePedia is a robust database for keeping record of parts stored in the factory’s engineering store. This project was motivated by time loss while trying to locate required part at the spare part store.\n
  StorePedia works on the principle of active information collation. In this case, Store items information and location will be stored by approved app users in a central repository, where it can be queried and retrieved by the app 
  users in need of it. This app comes with the following features:\n
  Add and Edit Store Item: Users can either add non existing store items or Edit existing store items with latest information to enable others get more accurate information.\n
  Delete Store Item: Users can tag an item as deprecated or Inaccurate if an item location has been replaced with another item or if the item information is misleading. Deleted Items will be indicated in Orange color and will be completely removed from data repository by cloud maintenance Robot.\n
  Search Store Item: StorePedia search engine is quite smart with capability of using keywords and part description to locate closely related part with minimum latency.\n
  Access control: Users can only get access to this app if approval is granted by the Admin. Access level is used to control who can delete or add part to repository.\n
  Why do you need StorePedia?\n
  Ease of use: Adding part to storage is very flexible; users only have to input most critical information about the part.\n
  Graphical: Identify part easily with photograph; users can get part information in one glance.\n
  Save time: Users can easily find and locate part in the store within seconds.\n
  Real time Update: Create or Updated part information on one device and it is available on all devices.\n
  Smart: search for part like you do on E-commerce platforms like Jumia and Aliexpress.
  ''';
