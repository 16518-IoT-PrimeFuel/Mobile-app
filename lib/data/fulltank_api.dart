import 'api_client.dart';

class FullTankApi {
  const FullTankApi(this.client);
  final ApiClient client;

  Future<dynamic> signIn(String username, String password) => client.post(
    '/authentication/sign-in',
    {'username': username, 'password': password},
  );
  Future<dynamic> signUp(Map<String, dynamic> body) =>
      client.post('/authentication/sign-up', body);
  Future<dynamic> users() => client.get('/users');
  Future<dynamic> user(int id) => client.get('/users/$id');
  Future<dynamic> buyerCompanies() => client.get('/buyer-companies');
  Future<dynamic> buyerCompany(int id) => client.get('/buyer-companies/$id');
  Future<dynamic> createBuyerCompany(Map<String, dynamic> body) =>
      client.post('/buyer-companies', body);
  Future<dynamic> updateBuyerCompany(int id, Map<String, dynamic> body) =>
      client.put('/buyer-companies/$id', body);
  Future<dynamic> providerCompanies() => client.get('/provider-companies');
  Future<dynamic> providerCompany(int id) =>
      client.get('/provider-companies/$id');
  Future<dynamic> createProviderCompany(Map<String, dynamic> body) =>
      client.post('/provider-companies', body);
  Future<dynamic> updateProviderCompany(int id, Map<String, dynamic> body) =>
      client.put('/provider-companies/$id', body);

  Future<dynamic> orders({int companyId = 1}) =>
      client.get('/fuel-orders/company/$companyId');
  Future<dynamic> order(int id) => client.get('/fuel-orders/$id');
  Future<dynamic> createOrder(Map<String, dynamic> body) =>
      client.post('/fuel-orders', body);
  Future<dynamic> confirmOrder(int id) =>
      client.post('/fuel-orders/$id/confirm');
  Future<dynamic> cancelOrder(int id) => client.post('/fuel-orders/$id/cancel');
  Future<dynamic> fuelRequests({int? buyerCompanyId, int? providerId}) =>
      client.get(
        '/fuel-requests?buyerCompanyId=$buyerCompanyId&providerId=$providerId',
      );
  Future<dynamic> createFuelRequest(Map<String, dynamic> body) =>
      client.post('/fuel-requests', body);
  Future<dynamic> acceptFuelRequest(int id) =>
      client.post('/fuel-requests/$id/accept');
  Future<dynamic> rejectFuelRequest(int id, String reason) =>
      client.post('/fuel-requests/$id/reject', {'reason': reason});

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
      client.post('/equipment/$equipmentId/favorite-provider', {
        'providerId': providerId,
      });

  Future<dynamic> payments() => client.get('/payments');
  Future<dynamic> paymentForOrder(int orderId) =>
      client.get('/payments/order/$orderId');
  Future<dynamic> createPayment(Map<String, dynamic> body) =>
      client.post('/payments', body);
  Future<dynamic> completePayment(int id, String transactionReference) =>
      client.post('/payments/$id/complete', {
        'transactionReference': transactionReference,
      });
  Future<dynamic> refundPayment(int id) => client.post('/payments/$id/refund');

  Future<dynamic> deliveries() => client.get('/deliveries');
  Future<dynamic> createDelivery(Map<String, dynamic> body) =>
      client.post('/deliveries', body);
  Future<dynamic> dispatchDelivery(int id) =>
      client.post('/deliveries/$id/dispatch');
  Future<dynamic> completeDelivery(int id) =>
      client.post('/deliveries/$id/complete');
  Future<dynamic> failDelivery(int id, String reason) =>
      client.post('/deliveries/$id/fail', {'reason': reason});
  Future<dynamic> vehicles({int? providerId}) => client.get(
    providerId == null ? '/vehicles' : '/vehicles?providerId=$providerId',
  );
  Future<dynamic> vehicle(int id) => client.get('/vehicles/$id');
  Future<dynamic> createVehicle(Map<String, dynamic> body) =>
      client.post('/vehicles', body);
  Future<dynamic> updateVehicle(int id, Map<String, dynamic> body) =>
      client.put('/vehicles/$id', body);
  Future<void> deleteVehicle(int id) => client.delete('/vehicles/$id');
  Future<dynamic> drivers({int? providerId}) => client.get(
    providerId == null ? '/drivers' : '/drivers?providerId=$providerId',
  );
  Future<dynamic> driver(int id) => client.get('/drivers/$id');
  Future<dynamic> createDriver(Map<String, dynamic> body) =>
      client.post('/drivers', body);
  Future<dynamic> updateDriver(int id, Map<String, dynamic> body) =>
      client.put('/drivers/$id', body);
  Future<void> deleteDriver(int id) => client.delete('/drivers/$id');
  Future<dynamic> providerRatings({int? companyId, int? providerId}) => client
      .get('/provider-ratings?companyId=$companyId&providerId=$providerId');
  Future<dynamic> createProviderRating(Map<String, dynamic> body) =>
      client.post('/provider-ratings', body);
  Future<dynamic> updateProviderRating(int id, Map<String, dynamic> body) =>
      client.put('/provider-ratings/$id', body);

  Future<dynamic> notifications(int userId) =>
      client.get('/notifications/user/$userId');
  Future<dynamic> unreadNotifications(int userId) =>
      client.get('/notifications/user/$userId/unread');
  Future<dynamic> createNotification(Map<String, dynamic> body) =>
      client.post('/notifications', body);
  Future<dynamic> markNotificationRead(int id) =>
      client.post('/notifications/$id/mark-as-read');
  Future<dynamic> analyticsForBuyer(int companyId) =>
      client.get('/analytics/buyers/$companyId');
  Future<dynamic> analyticsForProvider(int providerId) =>
      client.get('/analytics/providers/$providerId');
}
