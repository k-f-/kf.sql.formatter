// This file defines reusable rule constants and enums for formatting behavior.
// It can be expanded to support rule toggles, presets, or dialect-specific overrides.

export enum KeywordCase {
  Lower = 'lower',
  Upper = 'upper',
  Preserve = 'preserve'
}

export enum FunctionCase {
  Lower = 'lower',
  Upper = 'upper',
  Preserve = 'preserve'
}

export enum Dialect {
  Spark = 'spark',
  Hive = 'hive',
  ANSI = 'ansi'
}

export enum AliasScope {
  File = 'file',
  Select = 'select',
  None = 'none'
}

export enum ForceAliasMode {
  ExistingOnly = 'existingOnly',
  Off = 'off'
}

export enum SemicolonStyle {
  LeadingWhenMulti = 'leading-when-multi'
}
