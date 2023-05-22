import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/asset_grid/asset_grid_data_structure.dart';
import 'package:immich_mobile/modules/settings/providers/app_settings.provider.dart';
import 'package:immich_mobile/modules/settings/services/app_settings.service.dart';
import 'package:immich_mobile/shared/models/asset.dart';
import 'package:immich_mobile/shared/models/store.dart';
import 'package:immich_mobile/shared/providers/db.provider.dart';
import 'package:isar/isar.dart';

final archiveProvider = StreamProvider<RenderList>((ref) async* {
  final query = ref
      .watch(dbProvider)
      .assets
      .filter()
      .ownerIdEqualTo(Store.get(StoreKey.currentUser).isarId)
      .isArchivedEqualTo(true)
      .sortByFileCreatedAt();
  final settings = ref.watch(appSettingsServiceProvider);
  final groupBy =
      GroupAssetsBy.values[settings.getSetting(AppSettingsEnum.groupAssetsBy)];
  yield await RenderList.fromQuery(query, groupBy);
  await for (final _ in query.watchLazy()) {
    yield await RenderList.fromQuery(query, groupBy);
  }
});