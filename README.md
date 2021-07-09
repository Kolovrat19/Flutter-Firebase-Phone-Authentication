# phone_authentication

This project is a starting point for a Flutter application. Every app started with authentication. If you want use phone auth, you can apply this code in your project.

- 
- Create new user in Firebase.
- Create collection "Users" and add document with user credentials.

## Getting Started

- Create project in firebase: https://firebase.google.com/docs/android/setup
- Get your "google-services.json" file and put in "android/app" folder(your applicationId must match in "google-services.json" file).
- Enable "phone authentication" sign-in-methods in your project.
- Edit rules.
- Add in project settings "SHA1" and "SHA256".
- Change in file "LoginPhoneNumberView.dart" in 102 line country code or you can use "Country code picker".
- Run "pub get".


Warning! Code tested only on android.
