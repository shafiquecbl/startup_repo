// // ignore_for_file: depend_on_referenced_packages

// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:startup_repo/core/utils/app_constants.dart';

// /// Notification helper for Firebase Cloud Messaging + local notifications.
// ///
// /// Usage:
// /// 1. Add firebase_messaging, flutter_local_notifications to pubspec.yaml
// /// 2. Call `NotificationHelper.initialize()` in main.dart after Firebase.initializeApp()
// /// 3. Implement navigation logic in `_handleNotification()`
// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     // Handle notification that launched the app (terminated state)
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _handleNotification(initialMessage.data);
//     }

//     // Background handler (must be top-level function)
//     FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

//     // Platform-specific initialization
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings();
//     const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

//     _fln.initialize(
//       settings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationTapped,
//     );

//     // Foreground notifications
//     FirebaseMessaging.onMessage.listen((message) {
//       _showNotification(message);
//     });

//     // App opened from background via notification
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleNotification(message.data);
//     });
//   }

//   /// Show local notification when app is in foreground
//   static Future<void> _showNotification(RemoteMessage message) async {
//     final title = message.notification?.title ?? message.data['title'] ?? '';
//     final body = message.notification?.body ?? message.data['body'] ?? '';
//     final image = _extractImageUrl(message);

//     final payload = NotificationPayload(
//       title: title,
//       body: body,
//       image: image,
//       type: message.data['type'],
//       data: message.data,
//     );

//     if (image != null && image.isNotEmpty) {
//       try {
//         await _showImageNotification(payload);
//         return;
//       } catch (_) {
//         // Fall through to text notification
//       }
//     }
//     await _showTextNotification(payload);
//   }

//   static String? _extractImageUrl(RemoteMessage message) {
//     // Try data payload first
//     final dataImage = message.data['image'];
//     if (dataImage != null && dataImage.toString().isNotEmpty) {
//       return dataImage.toString().startsWith('http')
//           ? dataImage
//           : '${AppConstants.baseUrl}/storage/app/public/notification/$dataImage';
//     }

//     // Try notification payload
//     if (Platform.isAndroid) {
//       return message.notification?.android?.imageUrl;
//     } else if (Platform.isIOS) {
//       return message.notification?.apple?.imageUrl;
//     }
//     return null;
//   }

//   static Future<void> _showTextNotification(NotificationPayload payload) async {
//     final details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         AppConstants.appName,
//         AppConstants.appName,
//         importance: Importance.max,
//         priority: Priority.max,
//         styleInformation: BigTextStyleInformation(
//           payload.body,
//           htmlFormatBigText: true,
//           contentTitle: payload.title,
//           htmlFormatContentTitle: true,
//         ),
//       ),
//       iOS: const DarwinNotificationDetails(),
//     );

//     await _fln.show(0, payload.title, payload.body, details, payload: payload.toRawJson());
//   }

//   static Future<void> _showImageNotification(NotificationPayload payload) async {
//     final largeIconPath = await _downloadAndSaveFile(payload.image!, 'largeIcon');
//     final bigPicturePath = await _downloadAndSaveFile(payload.image!, 'bigPicture');

//     final details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         AppConstants.appName,
//         AppConstants.appName,
//         importance: Importance.max,
//         priority: Priority.max,
//         largeIcon: FilePathAndroidBitmap(largeIconPath),
//         styleInformation: BigPictureStyleInformation(
//           FilePathAndroidBitmap(bigPicturePath),
//           hideExpandedLargeIcon: true,
//           contentTitle: payload.title,
//           htmlFormatContentTitle: true,
//           summaryText: payload.body,
//           htmlFormatSummaryText: true,
//         ),
//       ),
//       iOS: const DarwinNotificationDetails(),
//     );

//     await _fln.show(0, payload.title, payload.body, details, payload: payload.toRawJson());
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/$fileName';
//     final response = await http.get(Uri.parse(url));
//     final file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }

//   @pragma('vm:entry-point')
//   static Future<void> _backgroundHandler(RemoteMessage message) async {
//     debugPrint('Background notification: ${message.notification?.title}');
//   }

//   static void _onNotificationTapped(NotificationResponse response) {
//     if (response.payload == null) return;
//     final payload = NotificationPayload.fromRawJson(response.payload!);
//     _handleNotification(payload.data ?? {});
//   }

//   /// TODO: Implement your navigation logic here
//   static void _handleNotification(Map<String, dynamic> data) {
//     debugPrint('Notification tapped: $data');
//     // Example:
//     // final type = data['type'];
//     // if (type == 'order') {
//     //   AppNav.push(OrderDetailScreen(orderId: data['order_id']));
//     // }
//   }
// }

// /// Notification payload model
// class NotificationPayload {
//   final String title;
//   final String body;
//   final String? image;
//   final String? type;
//   final Map<String, dynamic>? data;

//   const NotificationPayload({
//     required this.title,
//     required this.body,
//     this.image,
//     this.type,
//     this.data,
//   });

//   factory NotificationPayload.fromRawJson(String str) => NotificationPayload.fromJson(jsonDecode(str));

//   String toRawJson() => jsonEncode(toJson());

//   factory NotificationPayload.fromJson(Map<String, dynamic> json) => NotificationPayload(
//         title: json['title'] ?? '',
//         body: json['body'] ?? '',
//         image: json['image'],
//         type: json['type'],
//         data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
//       );

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'body': body,
//         'image': image,
//         'type': type,
//         'data': data,
//       };
// }
