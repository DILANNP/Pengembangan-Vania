import 'package:vania/vania.dart';
import 'package:vania_test/app/providers/route_service_provider.dart';

import 'cors.dart';

Map<String, dynamic> config = {
  'name': env('APP_NAME'),
  'url': env('APP_URL'),
  'cors': cors,
  'providers': <ServiceProvider>[
    RouteServiceProvider(),
  ],
};
