class Demo.HelloWorld : GLib.Object {
    public static int main(string[] args) {
        File docsets = File.new_for_path (Environment.get_home_dir () +
                "/.local/share/zeal/docsets");
        try {
            string directory = "./";
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);
                string type = "";

                if (FileUtils.test (path, FileTest.IS_REGULAR)) {
                    type += "| REGULAR ";
                }
                if (FileUtils.test (path, FileTest.IS_SYMLINK)) {
                    type += "| SYMLINK ";
                }
                if (FileUtils.test (path, FileTest.IS_DIR)) {
                    type += "| DIR ";
                }
                if (FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
                    type += "| EXECUTABLE ";
                }
                stdout.printf ("%s\t%s\n", name, type);
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }
        return 0;
    }
}