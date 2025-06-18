const std = @import("std");
const godot = @import("godot");
const builtin = @import("builtin");

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;
const allocator = gpa.allocator();

pub export fn my_extension_init(p_get_proc_address: godot.GDExtensionInterfaceGetProcAddress, p_library: godot.GDExtensionClassLibraryPtr, r_initialization: [*c]godot.GDExtensionInitialization) godot.GDExtensionBool {
    return godot.registerPlugin(p_get_proc_address, p_library, r_initialization, allocator, &init, &deinit);
}

fn init(_: ?*anyopaque, p_level: godot.GDExtensionInitializationLevel) void {
    if (p_level != godot.GDEXTENSION_INITIALIZATION_SCENE) {
        return;
    }

    const ExampleNode = @import("ExampleNode.zig");
    godot.registerClass(ExampleNode);
}

fn deinit(_: ?*anyopaque, p_level: godot.GDExtensionInitializationLevel) void {
    if (p_level == godot.GDEXTENSION_INITIALIZATION_CORE) {
        _ = gpa.deinit();
    }
}
