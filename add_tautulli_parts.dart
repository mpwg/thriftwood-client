#!/usr/bin/env dart

import 'dart:io';

void main(List<String> args) async {
  // List of remaining Tautulli files that need part directives
  final filesToFix = [
    'lib/api/tautulli/models/activity/activity.dart',
    'lib/api/tautulli/models/activity/session.dart',
    'lib/api/tautulli/models/libraries/library_media_info_record.dart',
    'lib/api/tautulli/models/libraries/search_results.dart',
    'lib/api/tautulli/models/libraries/recently_added.dart',
    'lib/api/tautulli/models/libraries/video_stream.dart',
    'lib/api/tautulli/models/libraries/single_library.dart',
    'lib/api/tautulli/models/libraries/audio_stream.dart',
    'lib/api/tautulli/models/libraries/library.dart',
    'lib/api/tautulli/models/libraries/media_info.dart',
    'lib/api/tautulli/models/libraries/libraries_table.dart',
    'lib/api/tautulli/models/libraries/media_info_parts.dart',
    'lib/api/tautulli/models/libraries/synced_item.dart',
    'lib/api/tautulli/models/libraries/metadata.dart',
    'lib/api/tautulli/models/libraries/library_watch_time_stats.dart',
    'lib/api/tautulli/models/libraries/table_library.dart',
    'lib/api/tautulli/models/libraries/library_media_info.dart',
    'lib/api/tautulli/models/miscellaneous/server.dart',
    'lib/api/tautulli/models/miscellaneous/server_info.dart',
    'lib/api/tautulli/models/miscellaneous/date_format.dart',
    'lib/api/tautulli/models/libraries/subtitle_stream.dart',
    'lib/api/tautulli/models/libraries/library_user_stats.dart',
    'lib/api/tautulli/models/libraries/search.dart',
    'lib/api/tautulli/models/libraries/search_result.dart',
    'lib/api/tautulli/models/miscellaneous/geolocation_info.dart',
    'lib/api/tautulli/models/miscellaneous/server_identity.dart',
    'lib/api/tautulli/models/miscellaneous/whois_info.dart',
    'lib/api/tautulli/models/system/update_check.dart',
    'lib/api/tautulli/models/libraries/library_name.dart',
    'lib/api/tautulli/models/miscellaneous/log.dart',
    'lib/api/tautulli/models/system/pms_update.dart',
    'lib/api/tautulli/models/miscellaneous/whois_subnet.dart',
    'lib/api/tautulli/models/users/user_name.dart',
    'lib/api/tautulli/models/users/table_user.dart',
    'lib/api/tautulli/models/users/users_table.dart',
    'lib/api/tautulli/models/users/user_logins.dart',
    'lib/api/tautulli/models/users/user_player_stats.dart',
    'lib/api/tautulli/models/users/user.dart',
    'lib/api/tautulli/models/users/user_login_record.dart',
    'lib/api/tautulli/models/history/series_data.dart',
    'lib/api/tautulli/models/users/user_ip_record.dart',
    'lib/api/tautulli/models/history/graph_data.dart',
    'lib/api/tautulli/models/users/user_ips.dart',
    'lib/api/tautulli/models/users/user_watch_time_stats.dart',
    'lib/api/tautulli/models/history/history_record.dart',
    'lib/api/tautulli/models/history/history.dart',
    'lib/api/tautulli/models/history/stream_data.dart',
    'lib/api/tautulli/models/history/home_stats.dart',
    'lib/api/tautulli/models/notifications/notification_log_record.dart',
    'lib/api/tautulli/models/notifications/newsletter.dart',
    'lib/api/tautulli/models/notifications/notifier_config.dart',
    'lib/api/tautulli/models/notifications/notifier_parameter.dart',
    'lib/api/tautulli/models/notifications/notification_logs.dart',
    'lib/api/tautulli/models/notifications/notifier.dart',
    'lib/api/tautulli/models/notifications/newsletter_log_record.dart',
    'lib/api/tautulli/models/notifications/newsletter_logs.dart',
    'lib/api/tautulli/models/notifications/notifier_config_actions.dart',
    'lib/api/tautulli/models/notifications/newsletter_config.dart',
  ];

  int processed = 0;
  int errors = 0;

  for (final filePath in filesToFix) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        print('File not found: $filePath');
        errors++;
        continue;
      }

      final content = await file.readAsString();

      // Extract filename without extension for the part directive
      final fileName = filePath.split('/').last.replaceAll('.dart', '');
      final partDirective = "part '$fileName.g.dart';";

      // Check if part directive already exists
      if (content.contains(partDirective)) {
        print('Part directive already exists in: $filePath');
        continue;
      }

      // Find the position to insert the part directive
      // Look for the last import statement
      final lines = content.split('\n');
      int insertIndex = -1;

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].startsWith('import ')) {
          insertIndex = i + 1;
        } else if (lines[i].startsWith('part ')) {
          // Part directives come after imports
          insertIndex = i;
          break;
        } else if (lines[i].trim().isEmpty) {
          // Continue looking
          continue;
        } else if (!lines[i].startsWith('//') && !lines[i].startsWith('/*')) {
          // Found non-import, non-comment line
          break;
        }
      }

      if (insertIndex == -1) {
        print('Could not find insertion point in: $filePath');
        errors++;
        continue;
      }

      // Insert the part directive
      lines.insert(insertIndex, '');
      lines.insert(insertIndex + 1, partDirective);

      final updatedContent = lines.join('\n');
      await file.writeAsString(updatedContent);

      print('Added part directive to: $filePath');
      processed++;
    } catch (e) {
      print('Error processing $filePath: $e');
      errors++;
    }
  }

  print('\nCompleted: $processed files processed, $errors errors');
}
