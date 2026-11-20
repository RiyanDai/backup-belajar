import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../common/error_handler.dart';
import '../../common/result_state.dart';
import '../../common/styles.dart';
import '../../common/thread_utils.dart';
import '../../data/model/story_response.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/story_provider.dart';
import '../widgets/state_widgets.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;
  final VoidCallback onBack;
  final void Function(Story story, String? address)? onOpenMapDetail;

  const StoryDetailScreen({
    super.key,
    required this.storyId,
    required this.onBack,
    this.onOpenMapDetail,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<StoryProvider>().fetchStoryDetail(widget.storyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.8),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.6),
            height: 0.8,
          ),
        ),
        title: Text(
          l10n.detailStoryTitle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        leading: Semantics(
          button: true,
          label: 'Back',
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: widget.onBack,
          ),
        ),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, _) {
          switch (provider.detailState) {
            case ResultState.loading:
              return LoadingStateWidget(message: l10n.loadingDetail);

            case ResultState.error:
              return ErrorStateWidget(
                message: ErrorHandler.mapErrorToMessage(
                  context,
                  provider.detailError,
                ),
                onRetry: () => provider.fetchStoryDetail(widget.storyId),
                retryText: l10n.retry,
              );

            case ResultState.hasData:
              final story = provider.storyDetail;
              if (story == null) {
                return EmptyStateWidget(
                  message: l10n.emptyStories,
                  onAction: widget.onBack,
                  actionText: l10n.back,
                );
              }
              return _ThreadDetailView(
                story: story,
                onOpenMapDetail: widget.onOpenMapDetail,
              );

            case ResultState.noData:
              return EmptyStateWidget(
                message: l10n.emptyStories,
                onAction: widget.onBack,
                actionText: l10n.back,
              );

            case ResultState.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ThreadDetailView extends StatelessWidget {
  final Story story;
  final void Function(Story story, String? address)? onOpenMapDetail;

  const _ThreadDetailView({
    required this.story,
    this.onOpenMapDetail,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isId = Localizations.localeOf(context).languageCode == 'id';
    final storyProvider = context.watch<StoryProvider>();
    final resolvedAddress = storyProvider.storyDetailAddress;
    final isLoadingAddress = storyProvider.isLoadingAddress;
    final detailTime = ThreadUtils.formatDetailTime(story.createdAtDate);
    final hasLocation = story.lat != null && story.lon != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header Row (Avatar, Name, Verified Badge, Time)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                child: Text(
                  story.name.isNotEmpty
                      ? story.name.substring(0, 1).toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            story.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ThreadUtils.formatRelativeTime(story.createdAtDate, isIndonesian: isId),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Story Text Content (Full, unconstrained)
          Text(
            story.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 14),

          // Story Media Photo (Rounded 16 with Hero animation)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.7),
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: story.id,
                child: Image.network(
                  story.photoUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 260,
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Interactive Location Card with Mini Map Preview
          if (hasLocation) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.8),
                ),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primaryDark,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: isLoadingAddress
                              ? Text(
                                  l10n.searchingAddress,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : Text(
                                  resolvedAddress ?? l10n.locationAttached,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        // Button to open full map detail
                        ElevatedButton(
                          onPressed: () {
                            onOpenMapDetail?.call(story, resolvedAddress);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.openMap,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.arrow_forward_rounded, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mini Map Preview
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(story.lat!, story.lon!),
                              zoom: 14.5,
                            ),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            markers: {
                              Marker(
                                markerId: const MarkerId('story_loc'),
                                position: LatLng(story.lat!, story.lon!),
                              ),
                            },
                          ),
                          // Clickable overlay to open map detail
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  onOpenMapDetail?.call(story, resolvedAddress);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Post Metadata (Time · Date · Platform)
          Text(
            '$detailTime · Story App for Android',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
