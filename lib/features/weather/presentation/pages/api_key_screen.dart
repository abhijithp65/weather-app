import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/constants.dart';

class ApiKeyScreen extends StatefulWidget {
  final VoidCallback onKeySaved;
  const ApiKeyScreen({super.key, required this.onKeySaved});

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final _controller = TextEditingController();
  bool _saving      = false;
  String? _error;

  Future<void> _save() async {
    final key = _controller.text.trim();
    if (key.isEmpty) {
      setState(() => _error = 'Please enter your API key.');
      return;
    }
    setState(() { _saving = true; _error = null; });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.apiKeyPrefKey, key);
    setState(() => _saving = false);
    widget.onKeySaved();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.clearDay,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌤️', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  const Text(
                    'Weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white10,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.white20, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter API Key',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Get a free key at openweathermap.org/api',
                          style: TextStyle(
                            color: AppColors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Material(
                          color: Colors.transparent,
                          child: TextField(
                            controller:  _controller,
                            style:       const TextStyle(color: Colors.white, fontSize: 15),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _save(),
                            decoration: InputDecoration(
                              hintText:  'e.g. a1b2c3d4e5f6...',
                              hintStyle: const TextStyle(
                                  color: AppColors.white50, fontSize: 14),
                              filled:    true,
                              fillColor: AppColors.white10,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.white20, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                              ),
                              errorText:   _error,
                              errorStyle:  const TextStyle(color: Color(0xFFFFB3B3)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: _saving ? null : _save,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: _saving
                                    ? const SizedBox(
                                        width: 20, height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF1E90FF),
                                        ),
                                      )
                                    : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: Color(0xFF1E64DC),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
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
      ),
    );
  }
}
