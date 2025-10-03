#!/usr/bin/env dart

import 'dart:io';

void main(List<String> args) async {
  // List of files that need part directives based on build_runner warnings
  final filesToFix = [
    'lib/api/sabnzbd/api.dart',
    'lib/api/sabnzbd/models/server.dart',
    'lib/api/radarr/models/import_list/import_list.dart',
    'lib/api/radarr/models/movie/movie_file.dart',
    'lib/api/radarr/models/movie/collection.dart',
    'lib/api/radarr/models/movie/alternate_titles.dart',
    'lib/api/radarr/models/movie/movie_file_quality.dart',
    'lib/api/radarr/models/movie/credits.dart',
    'lib/api/radarr/models/movie/rating.dart',
    'lib/api/radarr/models/extrafile/extra_file.dart',
    'lib/api/radarr/models/movie/movie_file_media_info.dart',
    'lib/api/radarr/models/root_folder/root_folder.dart',
    'lib/api/radarr/models/root_folder/unmapped_folder.dart',
    'lib/api/radarr/models/custom_format/custom_format.dart',
    'lib/api/radarr/models/manual_import/manual_import_rejection.dart',
    'lib/api/radarr/models/exclusions/exclusion.dart',
    'lib/api/radarr/models/manual_import/manual_import_update_data.dart',
    'lib/api/radarr/models/custom_format/custom_format_specifications.dart',
    'lib/api/radarr/models/manual_import/manual_import.dart',
    'lib/api/radarr/models/manual_import/manual_import_update.dart',
    'lib/api/radarr/models/manual_import/manual_import_file.dart',
    'lib/api/radarr/models/release/release.dart',
    'lib/api/radarr/models/system/status.dart',
    'lib/api/radarr/models/filesystem/file.dart',
    'lib/api/radarr/models/filesystem/filesystem.dart',
    'lib/api/radarr/models/image/image.dart',
    'lib/api/radarr/models/history/history_record.dart',
    'lib/api/radarr/models/filesystem/directory.dart',
    'lib/api/radarr/models/queue/queue_status.dart',
    'lib/api/radarr/models/filesystem/disk_space.dart',
    'lib/api/radarr/models/queue/queue_status_message.dart',
    'lib/api/radarr/models/history/history.dart',
    'lib/api/radarr/models/queue/queue_record.dart',
    'lib/api/radarr/models/tag/tag.dart',
    'lib/api/radarr/models/queue/queue.dart',
    'lib/api/radarr/models/quality_profile/format_item.dart',
    'lib/api/radarr/models/quality_profile/quality.dart',
    'lib/api/radarr/models/quality_profile/quality_definition.dart',
    'lib/api/radarr/models/quality_profile/quality_profile.dart',
    'lib/api/radarr/models/health_check/health_check.dart',
    'lib/api/radarr/models/quality_profile/language.dart',
    'lib/api/radarr/models/quality_profile/quality_revision.dart',
    'lib/api/radarr/models/quality_profile/item.dart',
    'lib/api/nzbget/models/version.dart',
    'lib/api/nzbget/models/status.dart',
    'lib/api/nzbget/api.dart',
    'lib/api/sonarr/models/series/series.dart',
    'lib/api/sonarr/models/series/image.dart',
    'lib/api/sonarr/models/series/alternate_title.dart',
    'lib/api/sonarr/models/series/series_statistics.dart',
    'lib/api/sonarr/models/series/rating.dart',
    'lib/api/sonarr/models/series/season.dart',
    'lib/api/sonarr/models/series/season_statistics.dart',
    'lib/api/sonarr/models/wanted_missing/missing_record.dart',
    'lib/api/sonarr/models/wanted_missing/missing.dart',
    'lib/api/sonarr/models/calendar/calendar.dart',
    'lib/api/sonarr/models/root_folder/root_folder.dart',
    'lib/api/sonarr/models/import_list/exclusion.dart',
    'lib/api/sonarr/models/root_folder/unmapped_folder.dart',
    'lib/api/sonarr/models/release/added_release.dart',
    'lib/api/sonarr/models/episode/episode.dart',
    'lib/api/sonarr/models/system/status.dart',
    'lib/api/sonarr/models/release/release.dart',
    'lib/api/sonarr/models/profile/quality_profile_item_quality.dart',
    'lib/api/sonarr/models/profile/language_profile.dart',
    'lib/api/sonarr/models/profile/language_profile_item_language.dart',
    'lib/api/sonarr/models/profile/quality_profile_item.dart',
    'lib/api/sonarr/models/profile/quality_profile.dart',
    'lib/api/sonarr/models/profile/quality_profile_cutoff.dart',
    'lib/api/sonarr/models/profile/language_profile_item.dart',
    'lib/api/sonarr/models/episode_file/episode_file_media_info.dart',
    'lib/api/sonarr/models/profile/language_profile_cutoff.dart',
    'lib/api/sonarr/models/episode_file/episode_file_quality.dart',
    'lib/api/sonarr/models/episode_file/episode_file_quality_quality.dart',
    'lib/api/sonarr/models/episode_file/episode_file_quality_revision.dart',
    'lib/api/sonarr/models/episode_file/episode_file_language.dart',
    'lib/api/sonarr/models/episode_file/episode_file.dart',
    'lib/api/sonarr/models/history/history_record.dart',
    'lib/api/sonarr/models/queue/queue_status_message.dart',
    'lib/api/sonarr/models/history/history.dart',
    'lib/api/sonarr/models/queue/queue.dart',
    'lib/api/sonarr/models/queue/queue_record.dart',
    'lib/api/sonarr/models/command/command.dart',
    'lib/api/sonarr/models/tag/tag.dart',
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
