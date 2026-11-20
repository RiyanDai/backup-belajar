import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../data/model/story_response.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/story_map_provider.dart';

class StoryMapDetailScreen extends StatefulWidget {
  final Story story;
  final String? initialAddress;
  final VoidCallback onBack;

  const StoryMapDetailScreen({
    super.key,
    required this.story,
    this.initialAddress,
    required this.onBack,
  });

  @override
  State<StoryMapDetailScreen> createState() => _StoryMapDetailScreenState();
}

class _StoryMapDetailScreenState extends State<StoryMapDetailScreen> {
  GoogleMapController? _mapController;
  late final LatLng _storyLocation;

  @override
  void initState() {
    super.initState();
    _storyLocation = LatLng(widget.story.lat ?? 0.0, widget.story.lon ?? 0.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StoryMapProvider>().init(
              lat: widget.story.lat,
              lon: widget.story.lon,
              initialAddress: widget.initialAddress,
            );
      }
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _handleBack() {
    context.read<StoryMapProvider>().reset();
    widget.onBack();
  }

  void _recenterMap() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _storyLocation, zoom: 15.5, tilt: 30.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mapProvider = context.watch<StoryMapProvider>();
    final dateFormat = DateFormat('EEEE, dd MMM yyyy • HH:mm');
    final formattedDate = dateFormat.format(widget.story.createdAtDate);

    final addressSnippet = mapProvider.resolvedAddress ??
        (mapProvider.isLoadingAddress
            ? l10n.searchingAddress
            : (widget.initialAddress ??
                'Lat: ${widget.story.lat?.toStringAsFixed(4)}, Lon: ${widget.story.lon?.toStringAsFixed(4)}'));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // 1. Full Screen Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _storyLocation,
              zoom: 14.5,
            ),
            mapType: mapProvider.currentMapType,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId('detail_${widget.story.id}'),
                position: _storyLocation,
                infoWindow: InfoWindow(
                  title: widget.story.name,
                  snippet: addressSnippet,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),

          // 2. Top Navigation Bar (Floating Pill)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Semantics(
                    button: true,
                    label: l10n.back,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      shadowColor: Colors.black26,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _handleBack,
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.map_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l10n.mapDetailTitle,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Map Type Switcher
                  Semantics(
                    button: true,
                    label: l10n.mapType,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      shadowColor: Colors.black26,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => mapProvider.toggleMapType(),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            mapProvider.currentMapType == MapType.normal
                                ? Icons.layers_outlined
                                : mapProvider.currentMapType == MapType.satellite
                                ? Icons.satellite_alt_rounded
                                : Icons.terrain_rounded,
                            color: AppColors.primaryDark,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Right Floating Action Buttons (Recenter & Zoom)
          Positioned(
            right: 16,
            bottom: 290,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _recenterMap,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        onTap: () => _mapController?.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(width: 1, height: 20, color: AppColors.border),
                      InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                        onTap: () => _mapController?.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          child: Icon(
                            Icons.remove_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Detail Card (Elevated & Protected by SafeArea)
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author & Date Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            widget.story.name.isNotEmpty
                                ? widget.story.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.story.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Resolved Address Chip / Loading
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: mapProvider.isLoadingAddress
                                ? Row(
                                    children: [
                                      const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.searchingAddress,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    addressSnippet,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      height: 1.3,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

        

                  
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
