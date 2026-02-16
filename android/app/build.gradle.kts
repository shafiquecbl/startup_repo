import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // id("com.google.gms.google-services")
    // id("com.google.firebase.firebase-perf")
    // id("com.google.firebase.crashlytics")
}

// Load environment variables from .env
val env: Properties = Properties().apply {
    val envFile = File(rootProject.projectDir.parentFile, ".env")
    if (envFile.exists()) {
        FileInputStream(envFile).use { load(it) }
    } else {
        throw IllegalStateException("Environment file .env not found.")
    }
}


android {
    namespace = "com.example.startup_repo"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = env.getProperty("BUNDLE_ID_ANDROID")
        minSdk = env.getProperty("MIN_SDK_VERSION")?.toInt() ?: 21
        targetSdk = env.getProperty("TARGET_SDK_VERSION")?.toInt() ?: 35
        versionCode = env.getProperty("ANDROID_VERSION_CODE")?.toInt() ?: 1
        versionName = env.getProperty("ANDROID_VERSION_NAME") ?: "1.0"
        multiDexEnabled = true

        resValue("string", "app_name", env.getProperty("APP_NAME") ?: "Music Transfer")
        
    }

    signingConfigs {
        create("release") {
            storeFile = file(env.getProperty("KEYSTORE_PATH") ?: "")
            storePassword = env.getProperty("KEYSTORE_PASSWORD")
            keyAlias = env.getProperty("KEYSTORE_ALIAS")
            keyPassword = env.getProperty("KEY_PASSWORD")
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
    
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}