/// API 配置中心
/// 1. 请不要将真实 API Key 提交到 GitHub
/// 2. 建议本地填写或使用环境变量
/// 3. 如果 dashscopeApiKey 为空，将自动使用 Mock fallback

/// DashScope API Key：https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key
class ApiConfig {
  static const String dashscopeApiKey = '';
  static const String dashscopeBaseUrl =
      'https://dashscope.aliyuncs.com/compatible-mode/v1';

  /// 通义千问模型名
  ///
  /// 可选值：
  /// - 'qwen-turbo'  — 速度快、成本低
  /// - 'qwen-plus'   — 质量更高、速度稍慢
  /// - 'qwen-max'    — 质量最高、成本较高
  static const String qwenModel = 'qwen-plus';
}
