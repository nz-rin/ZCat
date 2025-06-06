const std =  @import("std");

pub fn print(comptime format : [] const u8, args : anytype) void {
    _ = std.io.getStdOut().writer().print(format, args) catch {
        std.debug.print("Printing Failed\n", .{});
    };
}

pub fn eprint(comptime format : [] const u8, args : anytype) void {
    _ = std.io.getStdErr().writer().print(format, args) catch {
        std.debug.print("Printing Failed\n", .{});
    };
}

const malloc = std.heap.page_allocator;

pub fn main() !void{

    const argv : [][:0]u8 = try std.process.argsAlloc(malloc);
    if(argv.len < 2){
        eprint("No input File \n", .{});
        return;
    }

    var i : u64 = 1;
    while (i < argv.len) : (i += 1){
        const file = std.fs.cwd().openFile(argv[i], .{}) catch {
            eprint("failed to open file: {s}\n", .{argv[i]});
            return;
        };
        const file_size : u64 = file.getEndPos() catch {
            eprint("failed to seek file\n", .{});
            return;
        };

        const buffer = malloc.alloc(u8, file_size) catch {
            eprint("Buffer Allocation Failed", .{});
            return;
        };

        _ = file.read(buffer) catch {
            eprint("failed to read from file: {s}\n", .{argv[i]});
            return;
        };

        print("{s}", .{buffer});
        file.close();
        malloc.free(buffer);
    }

}
