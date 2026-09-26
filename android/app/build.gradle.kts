import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun loadRequiredProperties(fileName: String): Properties {
    val propertiesFile = file(fileName)
    if (!propertiesFile.exists()) {
        throw IllegalStateException("Properties file $fileName not found.")
    }
    return Properties().apply {
        FileInputStream(propertiesFile).use { load(it) }
    }
}

val appConfig: Properties = loadRequiredProperties("app_config.properties")
val signingPropertiesFile = file("signing.properties")
val signingProperties: Properties = Properties().apply {
    if (signingPropertiesFile.exists()) {
        FileInputStream(signingPropertiesFile).use { load(it) }
    }
}
val hasReleaseSigning: Boolean = signingPropertiesFile.exists()

android {
    namespace = "com.example.startup_repo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        resValues = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = appConfig.getProperty("application_id")
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        resValue("string", "app_name", appConfig.getProperty("app_name") ?: "Startup Repo")
        
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(signingProperties.getProperty("keystore_path"))
                storePassword = signingProperties.getProperty("keystore_password")
                keyAlias = signingProperties.getProperty("keystore_alias")
                keyPassword = signingProperties.getProperty("key_password")
            }
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            // The reusable starter stays buildable. Real apps provide ignored/CI release signing values.
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
    
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}