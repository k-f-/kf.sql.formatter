"use strict";
// This file defines reusable rule constants and enums for formatting behavior.
// It can be expanded to support rule toggles, presets, or dialect-specific overrides.
Object.defineProperty(exports, "__esModule", { value: true });
exports.SemicolonStyle = exports.ForceAliasMode = exports.AliasScope = exports.Dialect = exports.FunctionCase = exports.KeywordCase = void 0;
var KeywordCase;
(function (KeywordCase) {
    KeywordCase["Lower"] = "lower";
    KeywordCase["Upper"] = "upper";
    KeywordCase["Preserve"] = "preserve";
})(KeywordCase || (exports.KeywordCase = KeywordCase = {}));
var FunctionCase;
(function (FunctionCase) {
    FunctionCase["Lower"] = "lower";
    FunctionCase["Upper"] = "upper";
    FunctionCase["Preserve"] = "preserve";
})(FunctionCase || (exports.FunctionCase = FunctionCase = {}));
var Dialect;
(function (Dialect) {
    Dialect["Spark"] = "spark";
    Dialect["Hive"] = "hive";
    Dialect["ANSI"] = "ansi";
})(Dialect || (exports.Dialect = Dialect = {}));
var AliasScope;
(function (AliasScope) {
    AliasScope["File"] = "file";
    AliasScope["Select"] = "select";
    AliasScope["None"] = "none";
})(AliasScope || (exports.AliasScope = AliasScope = {}));
var ForceAliasMode;
(function (ForceAliasMode) {
    ForceAliasMode["ExistingOnly"] = "existingOnly";
    ForceAliasMode["Off"] = "off";
})(ForceAliasMode || (exports.ForceAliasMode = ForceAliasMode = {}));
var SemicolonStyle;
(function (SemicolonStyle) {
    SemicolonStyle["LeadingWhenMulti"] = "leading-when-multi";
})(SemicolonStyle || (exports.SemicolonStyle = SemicolonStyle = {}));
//# sourceMappingURL=rules.js.map