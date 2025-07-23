import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/professional.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(33.5731, -7.5898); // Casablanca fallback
  bool _locationPermissionGranted = false;

  final List<Professional> _mockProfessionals = const [
    Professional(
      name: 'Ahmed El Plombier',
      type: 'Plumber',
      phone: '+212600000001',
      location: 'Casablanca',
      photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    Professional(
      name: 'Fatima Tailleur',
      type: 'Tailor',
      phone: '+212600000002',
      location: 'Rabat',
      photoUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
    ),
    Professional(
      name: 'Youssef Electricien',
      type: 'Electrician',
      phone: '+212600000003',
      location: 'Marrakech',
      photoUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
    ),
    Professional(
      name: 'Sara Coiffeuse',
      type: 'Hairdresser',
      phone: '+212600000004',
      location: 'Fes',
      photoUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
    ),
  ];

  final Map<String, LatLng> _mockCoordinates = {
    'Ahmed El Plombier': LatLng(33.5731, -7.5898),
    'Fatima Tailleur': LatLng(34.0209, -6.8416),
    'Youssef Electricien': LatLng(31.6295, -7.9811),
    'Sara Coiffeuse': LatLng(34.0331, -5.0000),
  };

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      _locationPermissionGranted = status.isGranted;
    });
    if (_locationPermissionGranted) {
      // TODO: get actual user location and update _initialPosition
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Marker> _createMarkers() {
    return _mockProfessionals.map((professional) {
      final position = _mockCoordinates[professional.name] ?? _initialPosition;
      return Marker(
        markerId: MarkerId(professional.name),
        position: position,
        infoWindow: InfoWindow(
          title: professional.name,
          snippet: professional.type,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: _locationPermissionGranted
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              markers: _createMarkers(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  const Text(
                    'Location permission is required to show the map.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
    );
  }
}
