import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class WeatherSearchBar extends StatefulWidget {
  final void Function(String city) onSearch;
  final VoidCallback onLocationTap;
  final bool isLoading;

  const WeatherSearchBar({
    super.key,
    required this.onSearch,
    required this.onLocationTap,
    this.isLoading = false,
  });

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final _controller = TextEditingController();
  final _focus      = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    _focus.unfocus();
    widget.onSearch(city);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _controller,
              focusNode:  _focus,
              style:      const TextStyle(color: Colors.white, fontSize: 16),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submit(),
              onChanged:   (_) => setState(() {}),
              decoration: InputDecoration(
                hintText:  'Search city…',
                hintStyle: AppTextStyles.searchHint,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.white50, size: 20),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.white50, size: 18),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled:    true,
                fillColor: AppColors.white10,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: AppColors.white20, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: AppColors.white50, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _GlassButton(
          onTap: widget.isLoading ? null : widget.onLocationTap,
          child: widget.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.my_location_rounded,
                  color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        _GlassButton(
          onTap: _submit,
          child: const Icon(Icons.arrow_forward_rounded,
              color: Colors.white, size: 20),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _GlassButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white20, width: 0.5),
        ),
        child: Center(child: child),
      ),
    );
  }
}
