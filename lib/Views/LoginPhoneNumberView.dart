import 'dart:async';

import 'package:phone_authentication/Authenticaiton/Bloc/PhoneAuthBloc.dart';
import 'package:phone_authentication/Views/HomeMainView.dart';

import 'package:phone_authentication/Views/LoginMainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pinput/pin_put/pin_put.dart';

class LoginPhoneNumberView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginMainView()));
            },
          ),
          title: Text('Phone Login'),
        ),
        body: _PhoneAuthViewBuilder(),
      ),
    );
  }
}

class _PhoneAuthViewBuilder extends StatefulWidget {
  @override
  __PhoneAuthViewBuilderState createState() => __PhoneAuthViewBuilderState();
}

class __PhoneAuthViewBuilderState extends State<_PhoneAuthViewBuilder> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeNumberController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Timer _timer;
  int _start = 60;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
      listener: (previous, current) {
        if (current is PhoneAuthCodeVerificationSuccess) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeMainView()));
        } else if (current is PhoneAuthCodeVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthError) {
          _showSnackBarWithText(
              context: context, textValue: 'Uexpected error occurred.');
        } else if (current is PhoneAuthNumberVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthNumberVerificationSuccess) {
          _showSnackBarWithText(
              context: context,
              textValue: 'SMS code is sent to your mobile number.');
          _startTimer();
        } else if (current is PhoneAuthCodeAutoRetrevalTimeoutComplete) {
          _showSnackBarWithText(
              context: context, textValue: 'Time out for auto retrieval');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginMainView()));
        }
      },
      builder: (context, state) {
        if (state is PhoneAuthInitial) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthNumberVerificationSuccess) {
          return _codeVerificationWidget(context, state.verificationId);
        } else if (state is PhoneAuthNumberVerficationFailure) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthCodeVerficationFailure) {
          return _codeVerificationWidget(
            context,
            state.verificationId,
          );
        } else if (state is PhoneAuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }

  Widget _phoneNumberSubmitWidget(context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '+38(###)#######', filter: {"#": RegExp(r'[0-9]')});
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                autofocus: true,
                inputFormatters: [maskFormatter],
                obscureText: false,
                controller: _phoneNumberController,
                maxLength: 15,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () async {
            _verifyPhoneNumber(context);
            // final signcode = await SmsAutoFill().getAppSignature;
            // log(signcode);
          },
          child: Text('Submit'),
        )
      ],
    );
  }

  Widget _codeVerificationWidget(context, verifcationId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextField(
        //     controller: _codeNumberController,
        //     keyboardType: TextInputType.number,
        //     maxLength: 6,
        //     decoration: InputDecoration(
        //       hintText: 'Enter Code sent on phone',
        //       border: OutlineInputBorder(),
        //     ),
        //   ),
        // ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: PinPut(
              fieldsCount: 6,
              focusNode: _pinPutFocusNode,
              controller: _codeNumberController,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(.5),
                ),
              ),
            )),
        Text("$_start"),
        OutlinedButton(
          onPressed: () => _verifySMS(
            context,
            verifcationId,
          ),
          child: Text('verify'),
        )
      ],
    );
  }

  void _verifyPhoneNumber(BuildContext context) {
    BlocProvider.of<PhoneAuthBloc>(context)
        .add(PhoneAuthNumberVerified(phoneNumber: _phoneNumberController.text));
  }

  void _verifySMS(BuildContext context, String verificationCode) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthCodeVerified(
        verificationId: verificationCode, smsCode: _codeNumberController.text));
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _showSnackBarWithText(
      {@required BuildContext context, String textValue}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textValue)));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
