import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  /// 序列化为 JSON
  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'major': major,
        'degree': degree,
        'researchExperience': researchExperience,
        'interests': interests,
        'journals': journals,
      };

  /// 从 JSON 反序列化
  factory OnboardingData.fromJson(Map<String, dynamic> json) => OnboardingData(
        phone: json['phone'] ?? '',
        password: json['password'] ?? '',
        major: json['major'],
        degree: json['degree'],
        researchExperience: json['researchExperience'],
        interests: List<String>.from(json['interests'] ?? []),
        journals: List<String>.from(json['journals'] ?? []),
      );
}

/// 用户 Onboarding 服务
class OnboardingService extends ChangeNotifier {
  static const String _keyCompleted = 'onboarding_completed';
  static const String _keyUserData = 'onboarding_user_data';
  static const String _keyRegisteredUsers = 'registered_users'; // 手机号→密码映射

  OnboardingData _data = OnboardingData();
  bool _hasCompletedOnboarding = false;
  bool _isInitialized = false;

  // 已注册用户表：phone → password
  final Map<String, String> _registeredUsers = {};

  OnboardingData get data => _data;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isInitialized => _isInitialized;

  /// 初始化：从磁盘加载持久化数据
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();

      // 加载 onboarding 完成状态
      _hasCompletedOnboarding = prefs.getBool(_keyCompleted) ?? false;

      // 加载用户数据
      final userDataStr = prefs.getString(_keyUserData);
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
        _data = OnboardingData.fromJson(userData);
      }

      // 加载已注册用户表
      final usersStr = prefs.getString(_keyRegisteredUsers);
      if (usersStr != null) {
        final usersMap = jsonDecode(usersStr) as Map<String, dynamic>;
        _registeredUsers.clear();
        usersMap.forEach((key, value) {
          _registeredUsers[key] = value.toString();
        });
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('⚠️ OnboardingService init error: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyCompleted, _hasCompletedOnboarding);
      await prefs.setString(_keyUserData, jsonEncode(_data.toJson()));
      await prefs.setString(_keyRegisteredUsers, jsonEncode(_registeredUsers));
    } catch (e) {
      print('⚠️ OnboardingService save error: $e');
    }
  }

  /// 注册新用户
  /// 返回 true 成功，false 手机号已注册
  Future<bool> register(String phone, String password) async {
    if (_registeredUsers.containsKey(phone)) {
      return false; // 已存在
    }
    _registeredUsers[phone] = password;
    _data = _data.copyWith(phone: phone, password: password);
    await _save();
    notifyListeners();
    return true;
  }

  /// 登录验证
  /// 返回 true 成功，false 密码错误或用户不存在
  Future<bool> login(String phone, String password) async {
    if (!_registeredUsers.containsKey(phone)) {
      return false; // 用户不存在
    }
    if (_registeredUsers[phone] != password) {
      return false; // 密码错误
    }
    _data = _data.copyWith(phone: phone, password: password);
    await _save();
    notifyListeners();
    return true;
  }

  /// 检查手机号是否已注册
  bool isPhoneRegistered(String phone) => _registeredUsers.containsKey(phone);

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
    _save();
    notifyListeners();
  }

  /// 更新兴趣领域
  void updateInterests(List<String> interests) {
    _data = _data.copyWith(interests: interests);
    _save();
    notifyListeners();
  }

  /// 更新常读期刊
  void updateJournals(List<String> journals) {
    _data = _data.copyWith(journals: journals);
    _save();
    notifyListeners();
  }

  /// 完成 onboarding
  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    await _save();
    notifyListeners();
  }

  /// 重置 onboarding（用于测试）
  Future<void> reset() async {
    _data = OnboardingData();
    _hasCompletedOnboarding = false;
    _registeredUsers.clear();
    await _save();
    notifyListeners();
  }

  /// 登出：清除登录状态但保留注册数据
  Future<void> logout() async {
    _data = OnboardingData();
    _hasCompletedOnboarding = false;
    await _save();
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
