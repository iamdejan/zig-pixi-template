const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard target options allow specifying the CPU architecture, OS, etc.
    // The default is the host machine's target.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow selecting the optimization level.
    // Users can override this with `zig build -O ReleaseFast` or similar.
    // Note: The default is Debug mode when not specified. For stricter runtime
    // safety checks, users should explicitly use `-O ReleaseSafe` or higher.
    const mode = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-pixi-template",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = mode,
            .link_libc = true,
            .sanitize_c = .full,
        }),
    });

    // Install the artifact
    b.installArtifact(exe);

    // Create a "run" step to easily run the executable with `zig build run`
    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Create a "test" step to run all tests with `zig build test`
    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = mode,
            .link_libc = true,
        }),
    });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
