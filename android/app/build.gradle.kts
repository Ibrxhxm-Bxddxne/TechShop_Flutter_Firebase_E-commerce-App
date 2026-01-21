plugins {
    id("com.android.application")
    id("kotlin-android")

    // 🔥 Firebase (ACTIVÉ ICI)
    id("com.google.gms.google-services")

    // Flutter plugin (toujours en dernier)
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ecom_efm"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.ecom_efm"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
