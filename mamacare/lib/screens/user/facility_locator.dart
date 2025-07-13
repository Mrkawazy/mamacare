import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/facility.dart';
import 'package:url_launcher/url_launcher.dart';

class FacilityLocatorScreen extends StatefulWidget {
  const FacilityLocatorScreen({super.key});

  @override
  State<FacilityLocatorScreen> createState() => _FacilityLocatorScreenState();
}

class _FacilityLocatorScreenState extends State<FacilityLocatorScreen> {
  late Box<HealthFacility> _facilityBox;
  List<HealthFacility> _facilities = [];
  Position? _currentPosition;
  FacilityType? _selectedType;
  String _searchQuery = '';
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _facilityBox = Hive.box<HealthFacility>('facilities');
    _loadFacilities();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      _updateMapMarkers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: ${e.toString()}')),
      );
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _loadFacilities() async {
    setState(() {
      _facilities = _facilityBox.values.where((facility) {
        final matchesType = _selectedType == null || facility.type == _selectedType;
        final matchesSearch = facility.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            facility.address.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesType && matchesSearch;
      }).toList();
    });
    _updateMapMarkers();
  }

  void _updateMapMarkers() {
    _markers.clear();

    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    for (final facility in _facilities) {
      _markers.add(
        Marker(
          markerId: MarkerId(facility.id),
          position: LatLng(facility.latitude, facility.longitude),
          infoWindow: InfoWindow(
            title: facility.name,
            snippet: facility.address,
          ),
          icon: _getMarkerIcon(facility.type),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  BitmapDescriptor _getMarkerIcon(FacilityType type) {
    switch (type) {
      case FacilityType.clinic:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case FacilityType.hospital:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case FacilityType.maternity:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      case FacilityType.pharmacy:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
  }

  Future<void> _launchMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Facilities'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Facilities',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _loadFacilities();
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: FacilityType.values.map((type) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(_getFacilityTypeName(type)),
                          selected: _selectedType == type,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? type : null;
                            });
                            _loadFacilities();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 12,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controller) => _mapController = controller,
                  ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: _facilities.length,
              itemBuilder: (context, index) {
                final facility = _facilities[index];
                final distance = _currentPosition != null
                    ? Geolocator.distanceBetween(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                        facility.latitude,
                        facility.longitude,
                      ).round()
                    : null;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(_getFacilityIcon(facility.type)),
                    title: Text(facility.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(facility.address),
                        if (distance != null)
                          Text('${(distance / 1000).toStringAsFixed(1)} km away'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.directions),
                      onPressed: () => _launchMaps(
                        facility.latitude,
                        facility.longitude,
                      ),
                    ),
                    onTap: () {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(facility.latitude, facility.longitude),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getFacilityTypeName(FacilityType type) {
    switch (type) {
      case FacilityType.clinic:
        return 'Clinic';
      case FacilityType.hospital:
        return 'Hospital';
      case FacilityType.maternity:
        return 'Maternity';
      case FacilityType.pharmacy:
        return 'Pharmacy';
    }
  }

  IconData _getFacilityIcon(FacilityType type) {
    switch (type) {
      case FacilityType.clinic:
        return Icons.medical_services;
      case FacilityType.hospital:
        return Icons.local_hospital;
      case FacilityType.maternity:
        return Icons.pregnant_woman;
      case FacilityType.pharmacy:
        return Icons.local_pharmacy;
    }
  }
}