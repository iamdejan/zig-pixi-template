const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard target options allow specifying the CPU architecture, OS, etc.
    // The default is the host machine's target.
    const target = b.standardTargetOptions(.{});

    // Create the root module for the executable
    const exe_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .ReleaseSafe,
        .link_libc = true,
        .link_libcpp = true,
    });

    // Add C++ source files to the module
    exe_module.addCSourceFiles(.{
        .root = b.path("src/cpp"),
        .files = &.{"stl_wrappers.cpp"},
        .language = .cpp,
    });
    // Add include path for C++ headers
    exe_module.addIncludePath(b.path("src/cpp"));

    const exe = b.addExecutable(.{
        .name = "zig-pixi-template",
        .root_module = exe_module,
    });

    // Install the artifact
    b.installArtifact(exe);

    // Create a "run" step to easily run the executable with `zig build run`
    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Create the root module for tests
    const test_module = b.createModule(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = .ReleaseSafe,
        .link_libc = true,
        .link_libcpp = true,
    });

    // Add C++ source files to the test module
    test_module.addCSourceFiles(.{
        .root = b.path("src/cpp"),
        .files = &.{"stl_wrappers.cpp"},
        .language = .cpp,
    });
    // Add include path for C++ headers
    test_module.addIncludePath(b.path("src/cpp"));

    // Create a "test" step to run all tests with `zig build test`
    const tests = b.addTest(.{
        .root_module = test_module,
        .test_runner = .{ .path = b.path("src/test_runner.zig"), .mode = .simple },
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
