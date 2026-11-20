import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/error_handler.dart';
import '../../common/flavor_config.dart';
import '../../common/result_state.dart';
import '../../common/styles.dart';
import '../../common/thread_utils.dart';
import '../../data/model/story_response.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/story_provider.dart';
import '../widgets/state_widgets.dart';

class StoryListScreen extends StatefulWidget {
  final Function(String) onStoryTap;
  final VoidCallback onAddStoryTap;
  final VoidCallback onShowLogoutDialog;
  final VoidCallback onShowLanguageDialog;

  const StoryListScreen({
    super.key,
    required this.onStoryTap,
    required this.onAddStoryTap,
    required this.onShowLogoutDialog,
    required this.onShowLanguageDialog,
  });

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<StoryProvider>().fetchAllStories();
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StoryProvider>().fetchMoreStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFree = FlavorConfig.instance.isFree;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
 
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.8),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.6),
            height: 0.8,
          ),
        ),
         
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.all_inclusive_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              FlavorConfig.instance.appTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            label: 'Change Language',
            button: true,
            child: IconButton(
              icon: const Icon(
                Icons.language_rounded,
                color: AppColors.textPrimary,
                size: 22,
              ),
              tooltip: l10n.language,
              onPressed: widget.onShowLanguageDialog,
            ),
          ),
          Semantics(
            label: 'Logout',
            button: true,
            child: IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.textPrimary,
                size: 22,
              ),
              tooltip: l10n.logout,
              onPressed: widget.onShowLogoutDialog,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: Semantics(
        label: l10n.addNewStory,
        button: true,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          onPressed: widget.onAddStoryTap,
          child: const Icon(Icons.edit_outlined, size: 24),
        ),
      ),
      body: Column(
        children: [
          // Free tier promotional banner (Threads/Twitter subscription banner style)
          if (isFree)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 15,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.freeTierBanner,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Top "Start a thread..." composer bar (Threads / Twitter style)
          InkWell(
            onTap: widget.onAddStoryTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.6),
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.whatsOnYourMind,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.upload,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Timeline Feed
          Expanded(
            child: Consumer<StoryProvider>(
              builder: (context, provider, _) {
                switch (provider.storiesState) {
                  case ResultState.loading:
                    return LoadingStateWidget(message: l10n.loadingStories);

                  case ResultState.error:
                    return ErrorStateWidget(
                      message: ErrorHandler.mapErrorToMessage(
                        context,
                        provider.storiesError,
                      ),
                      onRetry: () => provider.fetchAllStories(),
                      retryText: l10n.retry,
                    );

                  case ResultState.noData:
                    return EmptyStateWidget(
                      message: l10n.emptyStories,
                      onAction: () => provider.fetchAllStories(),
                      actionText: l10n.retry,
                    );

                  case ResultState.hasData:
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => provider.fetchAllStories(),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount:
                            provider.stories.length +
                            (provider.hasMorePages ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == provider.stories.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Center(
                                child: provider.isFetchingMore
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            );
                          }

                          final story = provider.stories[index];
                          return _ThreadPostItem(
                            story: story,
                            onTap: () => widget.onStoryTap(story.id),
                          );
                        },
                      ),
                    );

                  case ResultState.initial:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadPostItem extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const _ThreadPostItem({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isId = Localizations.localeOf(context).languageCode == 'id';
    final timeAgo = ThreadUtils.formatRelativeTime(
      story.createdAtDate,
      isIndonesian: isId,
    );

    return Semantics(
      button: true,
      label: 'Story thread by ${story.name}',
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.6),
                  width: 0.8,
                ),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 14.0,
              bottom: 14.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Avatar & Continuous Threads Connecting Line
                Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.18,
                      ),
                      child: Text(
                        story.name.isNotEmpty
                            ? story.name.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 1.6,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.border.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Right Column: Author, Handle, Content, Media, and Actions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Name, Verified Badge, Time on left; Location Tag pinned on far right
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    story.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '·',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  timeAgo,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (story.lat != null && story.lon != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 12,
                                    color: AppColors.primaryDark,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    l10n.locationTaggedBadge,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Story Content Text
                      if (story.description.isNotEmpty)
                        Text(
                          story.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.35,
                            color: AppColors.textPrimary,
                          ),
                        ),

                      const SizedBox(height: 10),

                      // Attached Photo (Rounded Media Card)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.6),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Hero(
                              tag: 'story_${story.id}',
                              child: Image.network(
                                story.photoUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey.shade100,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: AppColors.textSecondary,
                                        size: 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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
    );
  }
}
