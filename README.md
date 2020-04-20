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
      
            |------ARViewController.swift                            #View Controller for AR Plant View
            
            |------Assets.xcassets                                   #Pictures and Icons for the xCode Project
            
            |------AppDelegate.swift                                 #Basic Xcode Functionality
            
            |------Base.lproj                                        #Storyboards for Project
            
            |------GoogleServices-info.plist                         #Info for firebase
            
            |------Item.swift                                        #SRC for different custom objects in CommunityGarden
            
            |------Info.plist                                        #Functionality for Location Services
            
            |------LiveCollectionViewCell.swift                      #Individual Cell for Life Collection View
            
            |------LivePlantsViewController.swift                    #View Controller for Toggle Button View
            
            |------LoginViewController.swift                         #View Controller for Login Screen
            
            |------MapAnnotation.swift                               #SRC for MapKit Location Services
            
            |------MapViewController.swift                           #View Controller for Map Landing Screen
            
            |------MyCollectionViewController.swift                  #View Controller for a Users Collection of Plants
            
            |------MyCollectionViewCell.swift                        #Individual Cell for displaying collection view
            
            |------PlantInfoViewController.swift                     #View Controller for Plant Information View
            
            |------PlantPlotViewController.swift                     #View Controller for handling plant plots
            
            |------PlantShopViewCell.swift                           #Cell for individual plants in the shop
            
            |------PlantShopViewController.swift                     #View Controller for Plant Shop Information View
            
            |------PlantingViewController.swift                      #View Controller for planting plants
            
            |------ProfileInfoViewController.swift                   #View Controller for User Profile View
            
            |------SignUpViewController.swift                        #View Controller for User Registration View
            
            |------StartViewController.swift                         #Load first view
            
            |------Utilities.swift                                   #Extraneous querie
            
            |------ViewController.swift                              #Default View Controller
            
            |------YourCollectionViewController.swift                #View Controller for User Plant Collection                        
            
|-----Resources                                                      
   
|-----Unity-Iphone.xCodeProject                                     

Build Instructions:

To Build and Run the project, open the project in xCode and run it. It should show up in the xCode Simulator. 
  ***This will be updated after the MVP stage, where we will explain instructions to download and run the app on the phone. 
