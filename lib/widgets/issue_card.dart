import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/issue_model.dart';

/// Reusable card widget for displaying issue information
class IssueCard extends StatefulWidget {
  final Issue issue;
  final VoidCallback? onTap;

  const IssueCard({
    super.key,
    required this.issue,
    this.onTap,
  });

  @override
  State<IssueCard> createState() => _IssueCardState();
}

class _IssueCardState extends State<IssueCard> {
  bool _testingImage = false;
  bool _retryingImage = false;
  DateTime? _imageLoadStart;
  String? _imageError;
  Key _imageKey = UniqueKey();

  Future<void> _testImageUrl(String url) async {
    setState(() {
      _testingImage = true;
      _imageError = null;
    });
    
    try {
      final uri = Uri.parse(url);
      
      if (!url.contains('firebasestorage.googleapis.com')) {
        throw 'Invalid image URL format - not a Firebase Storage URL';
      }

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 6);
      
      final headRequest = await client.headUrl(uri).timeout(const Duration(seconds: 6));
      final headResponse = await headRequest.close().timeout(const Duration(seconds: 6));
      
      final contentType = headResponse.headers.contentType?.toString() ?? 'unknown';
      if (!contentType.startsWith('image/')) {
        throw 'Invalid content type: $contentType';
      }

      final request = await client.getUrl(uri).timeout(const Duration(seconds: 6));
      request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-1024');
      final response = await request.close().timeout(const Duration(seconds: 6));
      
      String message = 'Image Test Results:\n';
      message += '• HTTP Status: ${response.statusCode}\n';
      message += '• Content Type: $contentType\n';
      message += '• Size: ${response.contentLength} bytes';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
        );
      }
      
      client.close(force: true);
    } catch (e) {
      setState(() => _imageError = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image test failed: $e'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _retryImage(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _testingImage = false);
    }
  }

  void _retryImage() {
    setState(() {
      _imageKey = UniqueKey();
      _imageError = null;
      _imageLoadStart = DateTime.now();
      _retryingImage = true;
    });
  }

  Color _getStatusColor(IssueStatus status) {
    switch (status) {
      case IssueStatus.resolved:
        return Colors.green;
      case IssueStatus.inProgress:
        return Colors.orange;
      case IssueStatus.unresolved:
        return Colors.red;
    }
  }

  String _getStatusLabel(IssueStatus status) {
    switch (status) {
      case IssueStatus.resolved:
        return 'Resolved';
      case IssueStatus.inProgress:
        return 'In Progress';
      case IssueStatus.unresolved:
        return 'Unresolved';
    }
  }

  IconData _getCategoryIcon(IssueCategory category) {
    switch (category) {
      case IssueCategory.road:
        return Icons.traffic;
      case IssueCategory.sanitation:
        return Icons.delete_outline;
      case IssueCategory.lighting:
        return Icons.lightbulb_outline;
      case IssueCategory.water:
        return Icons.water_drop_outlined;
      case IssueCategory.electricity:
        return Icons.bolt_outlined;
      case IssueCategory.other:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFD2B48C).withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.issue.imageUrls.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      key: _imageKey,
                      widget.issue.imageUrls.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        _imageLoadStart ??= DateTime.now();
                        if (loadingProgress == null) {
                          if (_retryingImage) {
                            _retryingImage = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Image loaded successfully'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          return child;
                        }
                        
                        final progress = loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                              loadingProgress.expectedTotalBytes!
                            : null;
                        
                        return Container(
                          height: 200,
                          color: Colors.grey[50],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 2,
                                  ),
                                ),
                                if (progress != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(progress * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        _imageError = error.toString();
                        return Container(
                          height: 200,
                          color: Colors.grey[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Failed to load image',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: _retryImage,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Retry'),
                                ),
                                if (_imageError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      _imageError!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.issue.status)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusLabel(widget.issue.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.issue.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.issue.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(widget.issue.category),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.issue.category.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(widget.issue.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.issue.address,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.issue.upvotes}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.comment_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.issue.comments.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              widget.issue.reporterName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.issue.reporterName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}