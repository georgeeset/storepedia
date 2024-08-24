# StorePedia

StorePedia is a robust database for keeping records of parts stored in the factory’s engineering store. This project was motivated by the time lost while trying to locate required parts at the spare part store.

## Features

- **Add and Edit Store Item**: Users can either add non-existing store items or edit existing store items with the latest information to enable others to get more accurate information.
- **Delete Store Item**: Users can tag an item as deprecated or inaccurate if an item location has been replaced with another item or if the item information is misleading. Deleted items will be indicated in orange color and will be completely removed from the data repository by a cloud maintenance robot.
- **Search Store Item**: StorePedia's search engine is quite smart, with the capability of using keywords and part descriptions to locate closely related parts with minimum latency.
- **Access Control**: Users can only get access to most of the app features if approval is granted by the Admin or users with higher access level. Access levels are used to determine who can edit, delete, add or mark part as exhausted. Only users with same company name can carry out operations on stored parts.

## Why Do You Need StorePedia?

- **Ease of Use**: Adding parts to storage is very flexible; users only have to input the most critical information about the part.
- **Graphical**: Identify parts easily with photographs; users can get part information at a glance.
- **Save Time**: Users can easily find and locate parts in the store within seconds, thereby reducing mean time to repair.
- **Stock Monitoring**: Department can easily identified exhausted parts and start replenishing process early 
- **Real-Time Update**: Create or update part information on one device, and it is available on all devices.
- **Smart Search**: Search for parts like you do on e-commerce platforms.

## Getting Started

To get started with StorePedia, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/georgeeset/storepedia.git
    ```
2. **Navigate to the project directory**:
    ```bash
    cd storepedia
    ```
3. **Install dependencies**:
    ```bash
    flutter pub get
    ```
4. **Run the app**:
    ```bash
    flutter run
    ```

## Contributing

We welcome contributions to StorePedia! Please fork the repository and create a pull request with your changes. Make sure to follow the coding standards and write tests for new features.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any inquiries or support, please contact georgeperfect4u@gmail.com