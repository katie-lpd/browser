const generate = @import("generate.zig");

const Console = @import("jsruntime").Console;

// DOM
const EventTarget = @import("dom/event_target.zig").EventTarget;
const N = @import("dom/node.zig");
const CharacterData = @import("dom/character_data.zig").CharacterData;
const Comment = @import("dom/comment.zig").Comment;
const Element = @import("dom/element.zig").Element;
const Document = @import("dom/document.zig").Document;

// HTML
pub const HTMLDocument = @import("html/document.zig").HTMLDocument;
const HTMLElem = @import("html/elements.zig");

// Interfaces
const interfaces = .{
    Console,

    // DOM
    EventTarget,
    N.Node,
    N.Types,
    CharacterData,
    Comment,
    Element,
    Document,

    // HTML
    HTMLDocument,
    HTMLElem.HTMLElement,
    HTMLElem.HTMLMediaElement,
    HTMLElem.Types,
};
pub const Interfaces = generate.Tuple(interfaces);
