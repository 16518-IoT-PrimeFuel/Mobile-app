import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/company_profile_repository.dart';

final companyProfileRepositoryProvider = Provider<CompanyProfileRepository>(
  (ref) => CompanyProfileRepository(ref.watch(fullTankApiProvider)),
);
