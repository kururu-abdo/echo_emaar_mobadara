import 'dart:async';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/utilities/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/otp_input_field.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../config/routes/route_names.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // 6 controllers + 6 focus nodes
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 60;
  bool _canResend = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first field
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNodes[0].requestFocus());
  }

  // ── Timer ─────────────────────────────────────────────────────────────────

  void _startTimer() {
    _secondsLeft = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get _currentOtp =>
      _controllers.map((c) => c.text).join();

  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    return '${'*' * (phone.length - 4)}${phone.substring(phone.length - 4)}';
  }

  void _clearFields() {
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    if (mounted) setState(() { _hasError = false; _errorMessage = null; });
  }

  // ── OTP box: on change ────────────────────────────────────────────────────

  void _onBoxChanged(int index, String value) {
    setState(() { _hasError = false; _errorMessage = null; });

    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto-submit when all 6 filled
    if (_currentOtp.length == 6) {
      _submit();
    }
  }

  void _onBoxBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  void _submit() {
    final otp = _currentOtp;
    final err = Validators.validateOtp(otp);
    if (err != null) {
      setState(() { _hasError = true; _errorMessage = err; });
      return;
    }
    context.read<AuthBloc>().add(
      VerifyOtpEvent(phoneNumber: widget.phoneNumber, otp: otp),
    );
  }

  // ── Resend ────────────────────────────────────────────────────────────────

  void _resend() {
    if (!_canResend) return;
    _clearFields();
    _startTimer();
    context.read<AuthBloc>().add(ResendOtpEvent(widget.phoneNumber));
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final shapes = context.shapes;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: colors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Clear entire stack → Home
            context.goNamed(RouteNames.home);
          }
          if (state is AuthError) {
            _clearFields();
            setState(() {
              _hasError = true;
              _errorMessage = state.message;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: spacing.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  spacing.verticalXL,

                  // ── Icon ────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(spacing.xl),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_outline_rounded,
                        size: 56, color: colors.primary),
                  ),

                  spacing.verticalLG,

                  // ── Title ────────────────────────────────────
                  Text(
                    'Verify your number',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                  ),

                  spacing.verticalSM,

                  Text(
                    'We sent a 6-digit code to',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  spacing.verticalXS,

                  Text(
                    _maskPhone(widget.phoneNumber),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                  ),

                  spacing.verticalXXL,

                  // ── OTP boxes ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (i) => _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        hasError: _hasError,
                        onChanged: (v) => _onBoxChanged(i, v),
                        onBackspace: () => _onBoxBackspace(i),
                      ),
                    ),
                  ),

                  // ── Error message ────────────────────────────
                  if (_hasError && _errorMessage != null) ...[
                    spacing.verticalMD,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 14, color: colors.error),
                        const SizedBox(width: 4),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: colors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],

                  spacing.verticalXL,

                  // ── Verify button ────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              shapes.borderRadiusSmall),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  spacing.verticalLG,

                  // ── Resend ───────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive it? ",
                        style: TextStyle(color: colors.textSecondary),
                      ),
                      _canResend
                          ? GestureDetector(
                              onTap: _resend,
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Text(
                              'Resend in ${_secondsLeft}s',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ],
                  ),

                  spacing.verticalMD,

                  // ── Change number ─────────────────────────────
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.edit_outlined,
                        size: 16, color: colors.primary),
                    label: Text(
                      'Change number',
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }




  Widget _buildOtpHeader(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 40),
      // The Architectural Container for the Lock Icon
      Container(
        height: 100, width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.primaryLight.withOpacity(0.2)),
          gradient: RadialGradient(colors: [context.colors.primary.withOpacity(0.2), Colors.transparent]),
        ),
        child: Icon(Icons.mark_email_unread_outlined, size: 40, color: context.colors.primaryLight),
      ),
      const SizedBox(height: 32),
      Text('Verify Code', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Text('Enter the 6-digit code sent to your phone', textAlign: TextAlign.center, style: context.textTheme.bodyMedium),
    ],
  );
}
}

// ── Single OTP box ─────────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;
    final isFocused = focusNode.hasFocus;

    return 
    
     Container(
      width: 50, height: 65,
      decoration: BoxDecoration(
        boxShadow: [
          if (focusNode.hasFocus) 
            BoxShadow(color: context.colors.primary.withOpacity(0.1), blurRadius: 15)
        ],
      ),
      child: TextField(
        // ... same logic
        decoration: InputDecoration(
          fillColor: focusNode.hasFocus ? context.colors.primary.withOpacity(0.05) : context.colors.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: hasError ? context.colors.error : context.colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.colors.primary, width: 2),
          ),
        ),
      ),
    );
    
    SizedBox(
      width: 46,
      height: 56,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: isFocused
                ? colors.primary.withOpacity(.07)
                : colors.inputBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(shapes.borderRadiusSmall),
              borderSide: BorderSide(
                color: hasError ? colors.error : colors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(shapes.borderRadiusSmall),
              borderSide:
                  BorderSide(color: colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(shapes.borderRadiusSmall),
              borderSide:
                  BorderSide(color: colors.error, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}