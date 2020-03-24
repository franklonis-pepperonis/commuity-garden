# community-garden
We will be using Xcode to develop CommunityGarden since it will begin as an iOS app. 

The third part libraries we will be using are: Google Maps API, Google Places API, Mapkit API, Azure SQL DB, Azure Hosting


Mapkit is an Apple library so we have included it in the build for our xcode project
Google Maps API: https://developers.google.com/maps/documentation/ios-sdk/start
Google Places API: https://developers.google.com/places/ios-sdk/start
Microsoft Azure: https://docs.microsoft.com/en-us/azure/app-service-mobile/app-service-mobile-ios-how-to-use-client-library


Folder/File Structure:

Our current project is stored in a folder called CommunityGarden which stores our similarily named XCode Project. In the CommunityGarden Folder, there is a main storyboard which contains all of our views and UI's. We also have 7 view controllers for each of our 7 views, which we split up so each one of our group members created one view. 

|--CommunityGarden
   |-----CommunityGarden.xCodeProject                             #Core XCode Project
   |-----CommunityGarden                                          #SRC for CommunityGarden
         |------Assets.xcassets                                   #Pictures and Icons for the xCode Project
         |------Base.lproj                                        #Storyboards for Project
         |------ARItem.swift                                      #SRC for Garden AR object
         |------AppDelegate.swift                                 #Basic Xcode Functionality
         |------Info.plist                                        #Functionality for Location Services
         |------LivePlantsViewController.swift                    #View Controller for Toggle Button in Plant Collection View
         |------MapAnnotation.swift                               #SRC for MapKit Location Services
         |------PlantInfoViewController.swift                     #View Controller for Plant Information View
         |------PlantShopViewController.swift                     #View Controller for Plant Shop Information View 
         |------ProfileInfoViewController.swift                   #View Controller for User Profile View
         |------ViewController.swift                              #Default View Controller
         |------YourCollectionViewController.swift                #View Controller for User Plant Collection
   |-----Resources                                                #Pictures and Icons
   |-----Unity-Iphone.xCodeProject                                #AR portion of Project

Build Instructions:

To Build and Run the project, open the project in xCode and run it. It should show up in the xCode Simulator. 
  ***This will be updated after the MVP stage, where we will explain instructions to download and run the app on the phone. 


*** We implemented our AR portion seperately, but we ended up having trouble merging the two of them together. They both work seperately, but we hit a massive roadblock combining the two. 
