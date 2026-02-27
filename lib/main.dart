import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/web_utility_js_datasource.dart';
import 'data/repositories/web_utility_repository_impl.dart';
import 'presentation/pages/web_utility_page.dart';

void main() {
  runApp(const WebUtilityDeskApp());
}

class WebUtilityDeskApp extends StatelessWidget {
  const WebUtilityDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Utility Desk',
      theme: AppTheme.build(),
      home: WebUtilityPage(
        repository: WebUtilityRepositoryImpl(
          dataSource: WebUtilityJsDataSourceImpl(),
        ),
      ),
    );
  }
}
