String timeAgo(DateTime postTime) {
  final Duration difference = DateTime.now().toUtc().difference(postTime);
  if (difference.inDays >= 365) return '${(difference.inDays / 365).floor()} y';
  if (difference.inDays >= 30) return '${(difference.inDays / 30).floor()} mo';
  if (difference.inDays >= 7) return '${(difference.inDays / 7).floor()} w';
  if (difference.inDays >= 1) return '${difference.inDays} d';
  if (difference.inHours >= 1) return '${difference.inHours} h';
  if (difference.inMinutes >= 1) return '${difference.inMinutes} min';
  return 'just now';
}