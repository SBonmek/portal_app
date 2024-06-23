import 'package:portal_app/core/errors/exceptions.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';
import 'package:portal_app/features/data/models/portal_model.dart';

abstract class PortalRemote {
  Future<List<PortalModel>> getPortalList();
}

class PortalRemoteImpl implements PortalRemote {
  // request api
  final HttpRequestWrapper _httpRequestWrapper = HttpRequestWrapperImpl();
  final String api = "links";

  @override
  Future<List<PortalModel>> getPortalList() async {
    try {
      List<PortalModel> portalList = [];
      final results =
          await _httpRequestWrapper.listPagedRestful(pagedRestful: api);

      if (results.isNotEmpty) {
        portalList.addAll(
          results
              .map((result) => PortalModel.fromJson(result))
              .cast<PortalModel>()
              .toList(),
        );
      }

      return portalList;
    } on ServerException catch (_) {
      rethrow;
    } catch (error) {
      throw ServerException(message: "GetPortalList | ${error.toString()}");
    }
  }
}
