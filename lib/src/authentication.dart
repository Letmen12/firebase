// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
    this.enableFreeSwag = false,
  });

  final bool loggedIn;
  final void Function() signOut;
  final bool enableFreeSwag;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100, bottom: 8),
          child: Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: StyledButton(
                onPressed: () {
                  !loggedIn ? context.push('/sign-in') : signOut();
                },
                child: !loggedIn
                    ? const Text(
                        'Нэвтрэх',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        ),
        Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                  onPressed: () {
                    context.push('/profile');
                  },
                  child: const Text('Profile')),
            )),
        Visibility(
            visible: enableFreeSwag,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                  onPressed: () {
                    throw Exception('free swag unimplemented');
                  },
                  child: const Text('Free swag!')),
            )),
      ],
    );
  }
}
