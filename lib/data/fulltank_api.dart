import 'api_client.dart';

class FullTankApi {
  const FullTankApi(this.client);
  final ApiClient client;

  Future<dynamic> signIn(
    String username,
    String password, {
    bool rememberMe = true,
  }) => client.post('/authentication/sign-in', {
    'username': username,
    'password': password,
    'rememberMe': rememberMe,
  });
  Future<dynamic> signOut() => client.post('/authentication/sign-out');
  Future<dynamic> signUp(Map<String, dynamic> body) =>
      client.post('/authentication/sign-up', body);
  Future<dynamic> requestPasswordReset(String email) =>
      client.post('/authentication/password-reset/request', {'email': email});
  Future<dynamic> resetPassword(String token, String newPassword) =>
      client.post('/authentication/password-reset/confirm', {
        'token': token,
        'newPassword': newPassword,
      });
  Future<dynamic> users() => client.get('/users');
  Future<dynamic> user(int id) => client.get('/users/$id');
  Future<dynamic> buyerCompanies() => client.get('/buyer-companies');
  Future<dynamic> buyerCompany(int id) => client.get('/buyer-companies/$id');
  Future<dynamic> customers() => client.get('/customers');
  Future<dynamic> customerSites(int customerId) =>
      client.get('/customers/$customerId/sites');
  Future<dynamic> createBuyerCompany(Map<String, dynamic> body) =>
      client.post('/buyer-companies', body);
  Future<dynamic> updateBuyerCompany(int id, Map<String, dynamic> body) =>
      client.put('/buyer-companies/$id', body);
  Future<dynamic> providerBuyerCompanies() =>
      client.get('/provider/buyer-companies');
  Future<dynamic> createProviderBuyerCompany(Map<String, dynamic> body) =>
      client.post('/provider/buyer-companies', body);
  Future<dynamic> providerCompanies() => client.get('/provider-companies');
  Future<dynamic> providerCompany(int id) =>
      client.get('/provider-companies/$id');
  Future<dynamic> createProviderCompany(Map<String, dynamic> body) =>
      client.post('/provider-companies', body);
  Future<dynamic> updateProviderCompany(int id, Map<String, dynamic> body) =>
      client.put('/provider-companies/$id', body);

  Future<dynamic> orders({required int companyId}) =>
      client.get('/fuel-orders/company/$companyId');
  Future<dynamic> providerOrders(int providerId) =>
      client.get('/fuel-orders/provider/$providerId');
  Future<dynamic> order(int id) => client.get('/fuel-orders/$id');
  Future<dynamic> createOrder(Map<String, dynamic> body) =>
      client.post('/fuel-orders', body);
  Future<dynamic> confirmOrder(int id) =>
      client.post('/fuel-orders/$id/confirm');
  Future<dynamic> cancelOrder(int id) => client.post('/fuel-orders/$id/cancel');
  Future<dynamic> fuelRequests({int? buyerCompanyId, int? providerId}) =>
      client.get(
        providerId == null
            ? '/replenishment-requests'
            : '/replenishment-requests/inbox',
      );

  Future<dynamic> createFuelRequest(Map<String, dynamic> body) =>
      client.post('/replenishment-requests', body);
  Future<dynamic> fuelRequest(int id) =>
      client.get('/replenishment-requests/$id');
  Future<dynamic> acceptFuelRequest(int id) =>
      client.post('/replenishment-requests/$id/accept');
  Future<dynamic> rejectFuelRequest(int id, String reason) =>
      client.post('/replenishment-requests/$id/reject', {'reason': reason});

  Future<dynamic> fuelProducts({int? providerId}) => client.get(
    providerId == null
        ? '/fuel-products'
        : '/fuel-products/provider/$providerId',
  );
  Future<dynamic> createFuelProduct(Map<String, dynamic> body) =>
      client.post('/fuel-products', body);
  Future<dynamic> updateFuelProduct(int id, Map<String, dynamic> body) =>
      client.put('/fuel-products/$id', body);
  Future<dynamic> updateStock(int id, double newStock) =>
      client.post('/fuel-products/$id/update-stock', {'newStock': newStock});
  Future<void> deleteFuelProduct(int id) => client.delete('/fuel-products/$id');
  Future<dynamic> equipment({int? companyId}) => client.get(
    companyId == null ? '/equipment' : '/equipment/company/$companyId',
  );
  Future<dynamic> equipmentById(int id) => client.get('/equipment/$id');
  Future<dynamic> createEquipment(Map<String, dynamic> body) =>
      client.post('/equipment', body);
  Future<dynamic> updateEquipment(int id, Map<String, dynamic> body) =>
      client.post('/equipment/$id/update', body);
  Future<dynamic> favoriteProvider(int equipmentId, int providerId) =>
      Future.error(
        UnsupportedError('Equipment favorite-provider is not supported'),
      );

  Future<dynamic> payments({required int companyId}) =>
      client.get('/payments/company/$companyId');
  Future<dynamic> paymentForOrder(int orderId) =>
      client.get('/payments/order/$orderId');
  Future<dynamic> createPayment(Map<String, dynamic> body) =>
      client.post('/payments', body);
  Future<dynamic> completePayment(int id, String transactionReference) =>
      client.post('/payments/$id/complete', {
        'transactionReference': transactionReference,
      });
  Future<dynamic> refundPayment(int id) => client.post('/payments/$id/refund');

  Future<dynamic> deliveries({required int providerId}) =>
      client.get('/deliveries');
  Future<dynamic> createDelivery(Map<String, dynamic> body) =>
      client.post('/deliveries', body);
  Future<dynamic> dispatchDelivery(int id) =>
      client.post('/deliveries/$id/start');
  Future<dynamic> startDelivery(int id) => client.post('/deliveries/$id/start');
  Future<dynamic> completeDelivery(int id, {double? deliveredVolume}) =>
      deliveredVolume == null
      ? Future.error(ArgumentError('deliveredVolume is required'))
      : client.post('/deliveries/$id/complete', {
          'deliveredVolume': deliveredVolume,
        });
  Future<dynamic> deliveryForOrder(int orderId) => Future.error(
    UnsupportedError('Delivery lookup by order is not supported'),
  );
  Future<dynamic> failDelivery(int id, String reason) =>
      client.post('/deliveries/$id/fail', {'reason': reason});
  Future<dynamic> vehicles() => client.get('/tankers');
  Future<dynamic> vehicle(int id) => client.get('/tankers/$id');
  Future<dynamic> createVehicle(Map<String, dynamic> body) =>
      client.post('/tankers', body);
  Future<dynamic> updateVehicle(int id, Map<String, dynamic> body) =>
      client.put('/tankers/$id', body);
  Future<dynamic> deactivateVehicle(int id) =>
      client.post('/tankers/$id/deactivate');
  Future<void> deleteVehicle(int id) async {
    await deactivateVehicle(id);
  }

  Future<dynamic> drivers() => client.get('/drivers');
  Future<dynamic> eligibleDrivers() => client.get('/drivers/eligible');
  Future<dynamic> driver(int id) => client.get('/drivers/$id');
  Future<dynamic> createDriver(Map<String, dynamic> body) =>
      client.post('/drivers', body);
  Future<dynamic> updateDriver(int id, Map<String, dynamic> body) =>
      client.put('/drivers/$id', body);
  Future<dynamic> deactivateDriver(int id) =>
      client.post('/drivers/$id/deactivate');
  Future<void> deleteDriver(int id) async {
    await deactivateDriver(id);
  }

  Future<dynamic> providerRatings({int? companyId, int? providerId}) =>
      Future.error(UnsupportedError('Provider ratings are not supported'));
  Future<dynamic> createProviderRating(Map<String, dynamic> body) =>
      Future.error(
        UnsupportedError('Provider rating mutations are not supported'),
      );
  Future<dynamic> updateProviderRating(int id, Map<String, dynamic> body) =>
      Future.error(
        UnsupportedError('Provider rating mutations are not supported'),
      );

  Future<dynamic> notifications([int? userId]) =>
      client.get('/me/notifications');
  Future<dynamic> unreadNotifications([int? userId]) =>
      client.get('/me/notifications/unread');
  Future<dynamic> createNotification(Map<String, dynamic> body) => Future.error(
    UnsupportedError('Generic notification creation is not supported'),
  );
  Future<dynamic> markNotificationRead(int id) =>
      client.post('/me/notifications/$id/read');
  Future<dynamic> analyticsForBuyer(int companyId) =>
      client.get('/analytics/buyers/$companyId');
  Future<dynamic> analyticsForProvider(int providerId) =>
      client.get('/analytics/providers/$providerId');

  Future<dynamic> replenishmentRequests([int? companyId]) =>
      client.get('/replenishment-requests');
  Future<dynamic> createReplenishmentRequest(Map<String, dynamic> body) =>
      client.post('/replenishment-requests', body);
  Future<dynamic> tracking(int deliveryId) =>
      client.get('/deliveries/$deliveryId/tracking');
  Future<dynamic> latestTracking(int deliveryId) =>
      client.get('/deliveries/$deliveryId/tracking');
  Future<dynamic> deliveryTimeline(int deliveryId) =>
      client.get('/deliveries/$deliveryId/timeline');
  Future<dynamic> notificationsV2([int? userId]) =>
      client.get('/me/notifications');
  Future<dynamic> eligibleFleet({int? providerId}) {
    return client.get('/tankers/eligible');
  }

  Future<dynamic> tanks(int companyId, int siteId) =>
      client.getV2('/api/v2/buyer-companies/$companyId/sites/$siteId/tanks');

  Future<dynamic> tank(int companyId, int siteId, String tankId) => client
      .getV2('/api/v2/buyer-companies/$companyId/sites/$siteId/tanks/$tankId');

  Future<String> exportReport({int? companyId, int? providerId}) {
    final path = providerId != null
        ? '/api/v2/reports/providers/$providerId/export'
        : companyId != null
        ? '/api/v2/reports/buyers/$companyId/export'
        : '/api/v2/reports/platform/export';
    return client.getV2Text(path);
  }
}
