// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/add.svg
  String get add => 'assets/icons/add.svg';

  /// File path: assets/icons/add_people.svg
  String get addPeople => 'assets/icons/add_people.svg';

  /// File path: assets/icons/app_logo.svg
  String get appLogo => 'assets/icons/app_logo.svg';

  /// File path: assets/icons/app_logo_zoomed.svg
  String get appLogoZoomed => 'assets/icons/app_logo_zoomed.svg';

  /// File path: assets/icons/apple.svg
  String get apple => 'assets/icons/apple.svg';

  /// File path: assets/icons/blue_tick.svg
  String get blueTick => 'assets/icons/blue_tick.svg';

  /// File path: assets/icons/calender.svg
  String get calender => 'assets/icons/calender.svg';

  /// File path: assets/icons/call.svg
  String get call => 'assets/icons/call.svg';

  /// File path: assets/icons/camera.svg
  String get camera => 'assets/icons/camera.svg';

  /// File path: assets/icons/chat.svg
  String get chat => 'assets/icons/chat.svg';

  /// File path: assets/icons/checkmark.svg
  String get checkmark => 'assets/icons/checkmark.svg';

  /// File path: assets/icons/conversation.svg
  String get conversation => 'assets/icons/conversation.svg';

  /// File path: assets/icons/copy.svg
  String get copy => 'assets/icons/copy.svg';

  /// File path: assets/icons/document.svg
  String get document => 'assets/icons/document.svg';

  /// File path: assets/icons/done.svg
  String get done => 'assets/icons/done.svg';

  /// File path: assets/icons/edit.svg
  String get edit => 'assets/icons/edit.svg';

  /// File path: assets/icons/exit.svg
  String get exit => 'assets/icons/exit.svg';

  /// File path: assets/icons/favourite_fill.svg
  String get favouriteFill => 'assets/icons/favourite_fill.svg';

  /// File path: assets/icons/favourite_outlined.svg
  String get favouriteOutlined => 'assets/icons/favourite_outlined.svg';

  /// File path: assets/icons/filter.svg
  String get filter => 'assets/icons/filter.svg';

  /// File path: assets/icons/flag.svg
  String get flag => 'assets/icons/flag.svg';

  /// File path: assets/icons/google.svg
  String get google => 'assets/icons/google.svg';

  /// File path: assets/icons/group.svg
  String get group => 'assets/icons/group.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/image.svg
  String get image => 'assets/icons/image.svg';

  /// File path: assets/icons/inbox.svg
  String get inbox => 'assets/icons/inbox.svg';

  /// File path: assets/icons/lock.svg
  String get lock => 'assets/icons/lock.svg';

  /// File path: assets/icons/lock_green.svg
  String get lockGreen => 'assets/icons/lock_green.svg';

  /// File path: assets/icons/notification.svg
  String get notification => 'assets/icons/notification.svg';

  /// File path: assets/icons/otp_graphics.svg
  String get otpGraphics => 'assets/icons/otp_graphics.svg';

  /// File path: assets/icons/payment.svg
  String get payment => 'assets/icons/payment.svg';

  /// File path: assets/icons/premium.svg
  String get premium => 'assets/icons/premium.svg';

  /// File path: assets/icons/profile.svg
  String get profile => 'assets/icons/profile.svg';

  /// File path: assets/icons/protection.svg
  String get protection => 'assets/icons/protection.svg';

  /// File path: assets/icons/raise_hand.svg
  String get raiseHand => 'assets/icons/raise_hand.svg';

  /// File path: assets/icons/search.svg
  String get search => 'assets/icons/search.svg';

  /// File path: assets/icons/send.svg
  String get send => 'assets/icons/send.svg';

  /// File path: assets/icons/settings.svg
  String get settings => 'assets/icons/settings.svg';

  /// File path: assets/icons/share.svg
  String get share => 'assets/icons/share.svg';

  /// File path: assets/icons/verified.svg
  String get verified => 'assets/icons/verified.svg';

  /// File path: assets/icons/warning.svg
  String get warning => 'assets/icons/warning.svg';

  /// List of all assets
  List<String> get values => [
    add,
    addPeople,
    appLogo,
    appLogoZoomed,
    apple,
    blueTick,
    calender,
    call,
    camera,
    chat,
    checkmark,
    conversation,
    copy,
    document,
    done,
    edit,
    exit,
    favouriteFill,
    favouriteOutlined,
    filter,
    flag,
    google,
    group,
    home,
    image,
    inbox,
    lock,
    lockGreen,
    notification,
    otpGraphics,
    payment,
    premium,
    profile,
    protection,
    raiseHand,
    search,
    send,
    settings,
    share,
    verified,
    warning,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [appLogo];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
