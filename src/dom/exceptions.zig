const std = @import("std");
const allocPrint = std.fmt.allocPrint;

const jsruntime = @import("jsruntime");
const Case = jsruntime.test_utils.Case;
const checkCases = jsruntime.test_utils.checkCases;

const parser = @import("../netsurf.zig");

// https://webidl.spec.whatwg.org/#idl-DOMException
pub const DOMException = struct {
    err: parser.DOMError,
    str: []const u8,

    pub const mem_guarantied = true;

    pub const ErrorSet = parser.DOMError;

    // static attributes
    pub const _INDEX_SIZE_ERR = 1;
    pub const _DOMSTRING_SIZE_ERR = 2;
    pub const _HIERARCHY_REQUEST_ERR = 3;
    pub const _WRONG_DOCUMENT_ERR = 4;
    pub const _INVALID_CHARACTER_ERR = 5;
    pub const _NO_DATA_ALLOWED_ERR = 6;
    pub const _NO_MODIFICATION_ALLOWED_ERR = 7;
    pub const _NOT_FOUND_ERR = 8;
    pub const _NOT_SUPPORTED_ERR = 9;
    pub const _INUSE_ATTRIBUTE_ERR = 10;
    pub const _INVALID_STATE_ERR = 11;
    pub const _SYNTAX_ERR = 12;
    pub const _INVALID_MODIFICATION_ERR = 13;
    pub const _NAMESPACE_ERR = 14;
    pub const _INVALID_ACCESS_ERR = 15;
    pub const _VALIDATION_ERR = 16;
    pub const _TYPE_MISMATCH_ERR = 17;

    // TODO: deinit
    pub fn init(alloc: std.mem.Allocator, err: parser.DOMError, callerName: []const u8) anyerror!DOMException {
        const errName = DOMException.name(err);
        const str = switch (err) {
            error.HierarchyRequest => try allocPrint(
                alloc,
                "{s}: Failed to execute '{s}' on 'Node': The new child element contains the parent.",
                .{ errName, callerName },
            ),
            error.NoError => unreachable,
            else => "", // TODO: implement other messages
        };
        return .{ .err = err, .str = str };
    }

    fn name(err: parser.DOMError) []const u8 {
        return switch (err) {
            error.IndexSize => "IndexSizeError",
            error.StringSize => "StringSizeError",
            error.HierarchyRequest => "HierarchyRequestError",
            error.WrongDocument => "WrongDocumentError",
            error.InvalidCharacter => "InvalidCharacterError",
            error.NoDataAllowed => "NoDataAllowedError",
            error.NoModificationAllowed => "NoModificationAllowedError",
            error.NotFound => "NotFoundError",
            error.NotSupported => "NotSupportedError",
            error.InuseAttribute => "InuseAttributeError",
            error.InvalidState => "InvalidStateError",
            error.Syntax => "SyntaxError",
            error.InvalidModification => "InvalidModificationError",
            error.Namespace => "NamespaceError",
            error.InvalidAccess => "InvalidAccessError",
            error.Validation => "ValidationError",
            error.TypeMismatch => "TypeMismatchError",
            error.NoError => unreachable,
        };
    }

    // JS properties and methods

    pub fn get_code(self: DOMException) u8 {
        return switch (self.err) {
            error.IndexSize => 1,
            error.StringSize => 2,
            error.HierarchyRequest => 3,
            error.WrongDocument => 4,
            error.InvalidCharacter => 5,
            error.NoDataAllowed => 6,
            error.NoModificationAllowed => 7,
            error.NotFound => 8,
            error.NotSupported => 9,
            error.InuseAttribute => 10,
            error.InvalidState => 11,
            error.Syntax => 12,
            error.InvalidModification => 13,
            error.Namespace => 14,
            error.InvalidAccess => 15,
            error.Validation => 16,
            error.TypeMismatch => 17,
            error.NoError => unreachable,
        };
    }

    pub fn get_name(self: DOMException) []const u8 {
        return DOMException.name(self.err);
    }

    pub fn get_message(self: DOMException) []const u8 {
        const errName = DOMException.name(self.err);
        return self.str[errName.len + 2 ..];
    }

    pub fn _toString(self: DOMException) []const u8 {
        return self.str;
    }
};

// Tests
// -----

pub fn testExecFn(
    _: std.mem.Allocator,
    js_env: *jsruntime.Env,
    comptime _: []jsruntime.API,
) !void {
    const err = "Failed to execute 'appendChild' on 'Node': The new child element contains the parent.";
    var cases = [_]Case{
        .{ .src = "let content = document.getElementById('content')", .ex = "undefined" },
        .{ .src = "let link = document.getElementById('link')", .ex = "undefined" },
        // HierarchyRequestError
        .{ .src = "var HierarchyRequestError; try {link.appendChild(content)} catch (error) {HierarchyRequestError = error} HierarchyRequestError.name", .ex = "HierarchyRequestError" },
        .{ .src = "HierarchyRequestError.code", .ex = "3" },
        .{ .src = "HierarchyRequestError.message", .ex = err },
        .{ .src = "HierarchyRequestError.toString()", .ex = "HierarchyRequestError: " ++ err },
    };
    try checkCases(js_env, &cases);
}
