const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard target options allow specifying the CPU architecture, OS, etc.
    // The default is the host machine's target.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options, defaulting to ReleaseSafe for strict checks.
    // ReleaseSafe enables runtime safety checks, making it "stricter" than ReleaseFast or ReleaseSmall.
    // Users can override this with `zig build -O ReleaseFast` or similar.
    const mode = b.standardOptimizeOption(.{ .default_value = .ReleaseSafe });

    const exe = b.addExecutable(.{
        .name = "zig-pixi-template",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = mode,
    });

    // To ensure strictness for any C/C++ code linked in the project,
    // you can enable specific sanitizers. Zig automatically links the
    // necessary runtime library when this is on.
    // Note: this assumes you might be using C/C++ interop.
    exe.link_libc = true; // Link the C standard library if needed
    exe.sanitize_c = .on; // Enable C sanitizers (e.g., Undefined Behavior Sanitizer)

    // Install the artifact
    b.installArtifact(exe);

    // Create a "run" step to easily run the executable with `zig build run`
    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Create a "test" step to run all tests with `zig build test`
    const tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = mode,
    });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

    // Make the "test" step run by default when just running `zig build` (optional, default is "install")
    b.get; // not necessary, install is fine.
}
