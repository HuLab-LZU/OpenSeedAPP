// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class TRZh extends TR {
  TRZh([String locale = 'zh']) : super(locale);

  @override
  String get title => 'OpenSeed';

  @override
  String get home => '主页';

  @override
  String get explore => '探索';

  @override
  String get settings => '设置';

  @override
  String get backToTop => '返回最上方';

  @override
  String get search => '搜索';

  @override
  String get refersh => '刷新';

  @override
  String get loadFailed => '加载失败';

  @override
  String get retry => '重试';

  @override
  String get notFound => '未找到';

  @override
  String get pageNotFound => '页面未找到';

  @override
  String pageNotFoundMessage(String title) {
    return '抱歉，$title 页面暂时不可用';
  }

  @override
  String get tryToUseOtherKeywords => '尝试一下其它关键词吧～';

  @override
  String get menu => '菜单';

  @override
  String get takePhoto => '从相机拍摄';

  @override
  String get selectFromGallery => '从相册选择';

  @override
  String get general => '通用';

  @override
  String get advanced => '高级';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get system => '系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get modelConfig => '模型设置';

  @override
  String get backendType => '后端选择';

  @override
  String get numberOfThreads => '线程数';

  @override
  String get setNumberOfThreads => '设置线程数';

  @override
  String get enterANumberGtZero => '请输入一个大于0的数';

  @override
  String get cancel => '取消';

  @override
  String get ok => 'OK';

  @override
  String get pleaseEnterANumberGtZero => '请输入一个大于0的数';

  @override
  String get topK => 'Top K';

  @override
  String get apiBaseUrl => 'API地址';

  @override
  String get notSet => '未设置';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get appVersion => 'V1.0.0';

  @override
  String get appIntroduction =>
      'OpenSeed 是一个开放种子示例软件，为AI赋能、大尺度且开源的种子分析生态而生。\n\n作者: Rainyl\n\nCopyright © 2025 OpenSeed All rights reserved.\n\n';

  @override
  String get appAuthor => '作者: Rainyl 及所有贡献者';

  @override
  String get appCopyright => 'Copyright © 2025 OpenSeed All rights reserved.';

  @override
  String get inference => '推理';

  @override
  String get results => '结果';

  @override
  String get inferenceFailed => '推理出错';

  @override
  String get inferenceImage => '推理图片';

  @override
  String get modelInfo => '模型信息';

  @override
  String get model => '模型名称';

  @override
  String get backend => '后端';

  @override
  String get memory => '内存占用';

  @override
  String get time => '推理延迟';

  @override
  String get flops => 'FLOPs';

  @override
  String get confidence => '置信度';

  @override
  String get details => '详细信息';

  @override
  String get copySpNameToClipboard => '复制物种名称到剪贴板';

  @override
  String get copiedSpNameToClipboard => '已复制物种名称到剪贴板';

  @override
  String get spInfoNotAvailable => 'Species information not available';

  @override
  String get pullToFetchMore => '获取更多';

  @override
  String get copyUrl => '复制链接';

  @override
  String get copiedUrlToClipboard => '已复制';

  @override
  String get openInBrowser => '在浏览器中打开';

  @override
  String get downloadingModel => '正在下载模型';

  @override
  String downloadingModelName(String modelName) {
    return '正在下载 $modelName...';
  }

  @override
  String get userCancelledDownload => '用户取消下载';

  @override
  String get startDownloading => '开始下载';

  @override
  String modelDownloadCompleted(String modelName) {
    return '模型 $modelName 下载完成';
  }

  @override
  String get downloadFailed => '下载失败';

  @override
  String get downloadCancelled => '下载已取消';

  @override
  String downloadFailedWithError(String error) {
    return '下载失败: $error';
  }

  @override
  String get modelFileNotExists => '模型文件不存在';

  @override
  String modelFileNotExistsDownload(String modelName) {
    return '模型 $modelName 的文件不存在，是否下载？';
  }

  @override
  String get download => '下载';
}
