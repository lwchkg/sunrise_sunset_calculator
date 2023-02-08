import 'package:flutter/material.dart';

const padding = 16.0;
const horizontalSpacing = 32.0;
const verticalSpacing = 16.0;

const maxMapHeight = 600.0;

const horizontalEdgeInsets = EdgeInsets.symmetric(horizontal: padding);
const verticalEdgeInsets = EdgeInsets.symmetric(vertical: padding);
const allEdgeInsets = EdgeInsets.all(padding);

const horizontalSpacingBox = SizedBox(width: horizontalSpacing);
const verticalSpacingBox = SizedBox(height: verticalSpacing);

getHeadingStyle(BuildContext context) =>
    Theme.of(context).textTheme.headlineSmall;

getBodyTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5) ??
    const TextStyle(height: 1.5);

const numberOutputStyle = TextStyle(fontWeight: FontWeight.bold);
