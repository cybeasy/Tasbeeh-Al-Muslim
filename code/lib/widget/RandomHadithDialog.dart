import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/models/Base/ApiModel.dart';
import 'package:tsbeh/models/HadesModel.dart';

class RandomHadithDialog extends StatefulWidget {
  final ApiModel initialHadith;

  const RandomHadithDialog({super.key, required this.initialHadith});

  static Future<void> show(BuildContext context) async {
    final hadith = await HadesModel.getRandomHadith();
    if (hadith == null || !context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => RandomHadithDialog(initialHadith: hadith),
    );
  }

  @override
  State<RandomHadithDialog> createState() => _RandomHadithDialogState();
}

class _RandomHadithDialogState extends State<RandomHadithDialog> {
  late ApiModel _hadith;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _hadith = widget.initialHadith;
  }

  Future<void> _loadNextHadith() async {
    setState(() => _isLoading = true);
    final next = await HadesModel.getRandomHadith();
    if (mounted && next != null) {
      setState(() {
        _hadith = next;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _shareHadith(String text) {
    final shareContent =
        "$text\n\nمن تطبيق تسبيح المسلم\nhttps://www.cybeasy.com/Tasbeeh-Al-Muslim/";
    SharePlus.instance.share(
      ShareParams(
        text: shareContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cleanText = HadesModel.getCleanText(_hadith);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
        elevation: 6,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, colorScheme),
              const SizedBox(height: 14),
              _buildContent(context, colorScheme, cleanText),
              const SizedBox(height: 16),
              _buildActions(context, colorScheme, cleanText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "من هدي النبوة",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant),
          tooltip: "إغلاق",
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ColorScheme colorScheme,
    String text,
  ) {
    final maxHeight = MediaQuery.of(context).size.height * 0.45;

    if (_isLoading) {
      return SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: RawScrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SelectableText(
              text.isNotEmpty ? text : _hadith.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.8,
                    fontSize: 15,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    ColorScheme colorScheme,
    String text,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _loadNextHadith,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("حديث آخر"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _shareHadith(text.isNotEmpty ? text : _hadith.title),
            icon: const Icon(Icons.share_rounded, size: 18),
            label: const Text("مشاركة"),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
