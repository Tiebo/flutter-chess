// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '简单待办';

  @override
  String get todo => '待办';

  @override
  String get profile => '我的';

  @override
  String get addTodo => '新增待办';

  @override
  String get todoTitle => '输入待办标题';

  @override
  String get add => '添加';

  @override
  String get contentCannotBeEmpty => '内容不能为空';

  @override
  String get personalCenter => '个人中心';

  @override
  String get username => '用户名';

  @override
  String get settings => '设置';

  @override
  String get helpAndFeedback => '帮助与反馈';

  @override
  String get aboutUs => '关于我们';

  @override
  String get logout => '退出登录';

  @override
  String get deleted => '已删除';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get lightTheme => '浅色主题';

  @override
  String get darkTheme => '深色主题';

  @override
  String get systemTheme => '跟随系统';
}
