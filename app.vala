using Gtk;
using Posix;

public class Application : Gtk.Window {
    private Gtk.Grid grid;
    private Gtk.Widget btnCurrent;
	public Application (string folder_path) {
		this.window_position = Gtk.WindowPosition.MOUSE;
		this.destroy.connect(Gtk.main_quit);
        int x, y;
        this.get_position(out x, out y);
        this.move(x-95, 350);
		this.set_border_width(0);
		var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		this.grid = new Gtk.Grid();
		this.grid.set_column_spacing(2);
        this.grid.set_row_spacing(2);
		this.grid.get_style_context().add_class("grid-bg");
		this.get_style_context().add_class("main-window");
    	Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default();
        try {
            Gtk.SizeGroup sizegroup = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
            var row = 1;
            var col = 1;
            GLib.Dir dir = GLib.Dir.open(folder_path, 0);
            string? name = null;
            while ((name = dir.read_name()) != null) {
                string path = Path.build_filename(folder_path, name);
                /*
                FileUtils.test (path, FileTest.IS_REGULAR)
                FileUtils.test (path, FileTest.IS_SYMLINK)
                FileUtils.test (path, FileTest.IS_DIR)
                FileUtils.test (path, FileTest.IS_EXECUTABLE)
                */
                if (col % 4 == 0) {
                    this.grid.insert_row(row+1);
                    col = 1;
                    row++;
                }

                if (FileUtils.test(path, FileTest.IS_DIR)) {
                    Gtk.Image imgBtn2 = new Gtk.Image.from_icon_name("document-open", Gtk.IconSize.DND);
                    Gtk.Button button2 = new Gtk.Button();
                    button2.get_style_context().add_class("button");

                    var button2Box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
                    var labelBtn2 = new Gtk.Label(name);

                    button2Box.pack_start(imgBtn2, false, false, 3);
                    button2Box.pack_start(labelBtn2, false, false, 3);

                    button2.add(button2Box);

                    button2.clicked.connect( ()=> { Posix.system("xdg-open \""+path+"\""); });

                    this.grid_attach(button2, col, row, 1, 1);
                    sizegroup.add_widget(button2);
                }
                if (!FileUtils.test(path, FileTest.IS_DIR)) {
                    string read;
                    string arquivo = folder_path+"/"+name;
                    FileUtils.get_contents(arquivo, out read);

                    string[] string_split = read.split("\n");
                    string iconname = "";
                    string appname = "";
                    string command = "";
                    foreach(var strplit in string_split) {
                        if(strplit.has_prefix("Icon=")) {
                            iconname = strplit.replace("Icon=", "");
                        }
                        if(strplit.has_prefix("Name=")) {
                            appname = strplit.replace("Name=", "");
                        }
                        if(strplit.has_prefix("Exec=")) {
                            command = strplit.replace("Exec=", "");
                        }
                    }
                    Gtk.Button button1 = new Gtk.Button();
                    button1.get_style_context().add_class("button");

                    var button1Box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
                    var labelBtn1 = new Gtk.Label(appname);

			        Gtk.IconInfo? icon_info = icon_theme.lookup_icon(iconname, 48, 0);
                    if(icon_info != null) {
                        var icon = new Gtk.Image.from_icon_name(iconname, Gtk.IconSize.DND);
                        button1Box.pack_start(icon, false, false, 3);
                    } else {
                        Gdk.Pixbuf iconPix = new Gdk.Pixbuf.from_file_at_size(iconname, 32, 32);
                        var icon = new Gtk.Image.from_pixbuf(iconPix);
                        button1Box.pack_start(icon, false, false, 3);
                    }
                    
                    button1Box.pack_start(labelBtn1, false, false, 3);

                    button1.add(button1Box);

                    button1.clicked.connect( ()=> { Posix.system(command); });

                    this.grid_attach(button1, col, row, 1, 1);
                    sizegroup.add_widget(button1);
                }
                col++;
            }
        } catch (FileError err) {
            GLib.stderr.printf(err.message);
        } catch (GLib.Error err) {
            GLib.stderr.printf(err.message);
        }
        box.add(grid);
		this.add (box);
	}

    public void grid_attach (Gtk.Widget button2, int left, int top, int width, int height) {
        if (left == 1) {
            this.grid.attach(button2, left, top, width, height);
        } else {
            this.grid.attach_next_to(button2, this.btnCurrent, Gtk.PositionType.RIGHT, width, height);
        }
        this.btnCurrent = button2;
    }

	public static int main (string[] args) {
		Gtk.init(ref args);

		var css_provider = new Gtk.CssProvider();
		try {
            //css_provider.load_from_path(Environment.get_current_dir()+"/app.css");
    		css_provider.load_from_path(Environment.get_home_dir()+"/Projetos/plankfolderlauncher/app.css");
    	} catch (GLib.Error e) {
            warning("Error while loading css: %s", e.message);
    	}

        //GLib.stdout.printf ("CSS: %s", Environment.get_current_dir ());

		string folder_path = "";
		if (args[1] != null) {
			folder_path = args[1];
		}

		Application app = new Application(folder_path);

		Gtk.StyleContext.add_provider_for_screen(
            app.get_screen(),
            css_provider,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);
		app.get_style_context().add_class("main-window");

		app.show_all ();
		Gtk.main ();
		return 0;
	}
}
