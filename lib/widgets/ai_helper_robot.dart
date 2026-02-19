Widget navIcon(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.6),
              color.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(2, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    ),
  );
}
