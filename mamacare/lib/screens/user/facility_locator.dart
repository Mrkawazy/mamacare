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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      _facilityBox = Hive.box<HealthFacility>('facilities');
      await _getCurrentLocation();
      await _loadFacilities();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing data: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      if (mounted) {
        setState(() => _currentPosition = position);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: ${e.toString()}')),
        );
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
      }
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied'),
          ),
        );
      }
      return false;
    }

    return true;
  }

  Future<void> _loadFacilities() async {
    try {
      final filteredFacilities = _facilityBox.values.where((facility) {
        final matchesType = _selectedType == null || facility.type == _selectedType;
        final matchesSearch = _searchQuery.isEmpty ||
            facility.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            facility.address.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesType && matchesSearch;
      }).toList();

      if (mounted) {
        setState(() => _facilities = filteredFacilities);
        _updateMapMarkers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading facilities: ${e.toString()}')),
        );
      }
    }
  }

  void _updateMapMarkers() {
    final newMarkers = <Marker>{};

    if (_currentPosition != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    for (final facility in _facilities) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(facility.id),
          position: LatLng(facility.latitude, facility.longitude),
          infoWindow: InfoWindow(
            title: facility.name,
            snippet: facility.address,
            onTap: () => _launchMaps(facility.latitude, facility.longitude),
          ),
          icon: _getMarkerIcon(facility.type),
          onTap: () {
            _mapController.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(facility.latitude, facility.longitude),
                14,
              ),
            );
          },
        ),
      );
    }

    if (mounted) {
      setState(() => _markers..clear()..addAll(newMarkers));
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
    try {
      final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not launch maps');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching maps: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Facilities'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                          _searchQuery = value;
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
                                  _selectedType = selected ? type : null;
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
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition != null
                          ? LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            )
                          : const LatLng(0, 0), // Fallback position
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                              CameraUpdate.newLatLngZoom(
                                LatLng(facility.latitude, facility.longitude),
                                14,
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