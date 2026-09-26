import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:startup_repo/imports.dart';

import '../../services/connectivity/connectivity_service.dart';

final class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({required this.connectivityService, required this.child, super.key});

  final ConnectivityService connectivityService;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        Align(
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder<InternetStatus?>(
            valueListenable: connectivityService.status,
            builder: (BuildContext context, InternetStatus? status, Widget? _) {
              final bool isOffline = status == InternetStatus.disconnected;
              final String message = 'connectivity_offline'.tr;
              final ColorScheme colorScheme = context.theme.colorScheme;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: !isOffline
                    ? const SizedBox.shrink()
                    : SafeArea(
                        minimum: AppPadding.p8,
                        child: Semantics(
                          liveRegion: true,
                          label: message,
                          child: Material(
                            key: const ValueKey<String>('connectivity-banner'),
                            color: colorScheme.errorContainer,
                            shape: AppRadius.r24Shape,
                            child: Padding(
                              padding: AppPadding.p8,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  AppIcon(
                                    icon: HugeIcons.strokeRoundedWifiOff01,
                                    size: 20.sp,
                                    color: colorScheme.onErrorContainer,
                                  ),
                                  SizedBox(width: 8.sp),
                                  Flexible(
                                    child: Text(
                                      message,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.font12.copyWith(
                                        color: colorScheme.onErrorContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.sp),
                                  TextButton(
                                    key: const ValueKey<String>('connectivity-retry'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorScheme.onErrorContainer,
                                    ),
                                    onPressed: () => unawaited(connectivityService.retry()),
                                    child: Text('retry'.tr),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
