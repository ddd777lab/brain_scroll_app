import 'package:flutter/material.dart';

/// 用户 Onboarding 数据模型
class OnboardingData {
  String phone;
  String password;
  String? major;
  String? degree;
  int? researchExperience;
  List<String> interests;
  List<String> journals;

  OnboardingData({
    this.phone = '',
    this.password = '',
    this.major,
    this.degree,
    this.researchExperience,
    this.interests = const [],
    this.journals = const [],
  });

  /// 复制并更新
  OnboardingData copyWith({
    String? phone,
    String? password,
    String? major,
    String? degree,
    int? researchExperience,
    List<String>? interests,
    List<String>? journals,
  }) {
    return OnboardingData(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      major: major ?? this.major,
      degree: degree ?? this.degree,
      researchExperience: researchExperience ?? this.researchExperience,
      interests: interests ?? List.from(this.interests),
      journals: journals ?? List.from(this.journals),
    );
  }

  /// 检查是否完成 onboarding
  bool get isCompleted => phone.isNotEmpty;
}

/// 用户 Onboarding 服务
class OnboardingService extends ChangeNotifier {
  OnboardingData _data = OnboardingData();
  bool _hasCompletedOnboarding = false;

  OnboardingData get data => _data;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  /// 更新手机号
  void updatePhone(String phone) {
    _data = _data.copyWith(phone: phone);
    notifyListeners();
  }

  /// 更新密码
  void updatePassword(String password) {
    _data = _data.copyWith(password: password);
    notifyListeners();
  }

  /// 更新学术背景
  void updateAcademicBackground({
    String? major,
    String? degree,
    int? researchExperience,
  }) {
    _data = _data.copyWith(
      major: major,
      degree: degree,
      researchExperience: researchExperience,
    );
    notifyListeners();
  }

  /// 更新兴趣领域
  void updateInterests(List<String> interests) {
    _data = _data.copyWith(interests: interests);
    notifyListeners();
  }

  /// 更新常读期刊
  void updateJournals(List<String> journals) {
    _data = _data.copyWith(journals: journals);
    notifyListeners();
  }

  /// 完成 onboarding
  void completeOnboarding() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  /// 重置 onboarding（用于测试）
  void reset() {
    _data = OnboardingData();
    _hasCompletedOnboarding = false;
    notifyListeners();
  }

  /// 获取用户显示名称
  String getDisplayName() {
    if (_data.phone.isNotEmpty) {
      return '用户${_data.phone.substring(_data.phone.length - 4)}';
    }
    return '未登录用户';
  }

  /// 获取用户详细信息
  String getUserDetails() {
    final parts = <String>[];
    if (_data.major != null && _data.major!.isNotEmpty) {
      parts.add(_data.major!);
    }
    if (_data.degree != null && _data.degree!.isNotEmpty) {
      parts.add(_data.degree!);
    }
    return parts.isNotEmpty ? parts.join(' · ') : 'ID: 暂缺';
  }
}
