using Gtk;
using Posix;
using GLib;

public class Application : Gtk.Window {
    private Gtk.Grid grid;
    private Gtk.Widget btnCurrent;
	public Application (string folder_path) {
		int x, y;
		this.window_position = Gtk.WindowPosition.MOUSE;
		this.destroy.connect(Gtk.main_quit);
        this.get_position(out x, out y);
        this.move(x-100, y-90);
        this.set_border_width(0);
        this.set_deletable(false);
        this.set_resizable(false);
//        this.set_type_hint(Gdk.WindowTypeHint.DIALOG);Granite
//        this.type = Gtk.WindowType.TOPLEVEL;
//        GLib.Object(type: Gtk.WindowType.POPUP);
		Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		this.grid = new Gtk.Grid();
		this.grid.set_column_spacing(2);
        this.grid.set_row_spacing(2);

//        var pointer = Gdk.Display.get_default ().get_device_manager ().get_client_pointer ();
//        var display = Gdk.Display.get_default();
//        var cursor = new Gdk.Cursor.from_name(display, "pointer_cursor"); //Gdk.CursorType.WATCH
//        this.get_window().set_cursor(cursor);

//        Gtk.HeaderBar headerbar = new Gtk.HeaderBar();

        Gtk.Box headerbar = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        Gtk.Label label = new Gtk.Label ("");
        label.set_use_markup (true);
        label.set_line_wrap (true);

        string[] paths = folder_path.split("/");
        string labelText = "";
        if (paths[paths.length - 1] != "") {
            labelText = paths[paths.length - 1];
        } else {
            labelText = paths[paths.length - 2];
        }
        label.set_text(labelText);
        headerbar.add(label);
        headerbar.set_size_request(0, 50);
        label.set_vexpand(true);
        label.set_hexpand(true);
        box.pack_start(headerbar);

//        this.set_titlebar(headerbar);
//        var pointer = Gdk.Display.get_default ().get_device_manager ().get_client_pointer ();
//        var display = Gdk.Display.get_default();
//        var cursor = new Gdk.Cursor.from_name(display, "pointer_cursor"); //Gdk.CursorType.WATCH
//        this.get_window().set_cursor(cursor);

        string css = """
            .custom-GtkWindow GtkHeaderBar,
            GtkHeaderBar,
            .header-bar,
            .header-bar .title,
            headerbar entry,
            headerbar spinbutton,
            headerbar button,
            headerbar separator,
            .default-decoration,
            .default-decoration .titlebutton,
            window.ssd headerbar.titlebar,
            window.ssd headerbar.titlebar button.titlebutton,
            .header-bar.default-decoration {
                border: 0 none;
                box-shadow: 0 0 0;
                padding: 0;
                margin: 0;
                opacity: 0;
            }
            .AppWindow {
                background: transparent;
                margin: 25px;
                border: 0 none;
                border-radius: 5px;
                box-shadow: 0 0 0;
            }
            .AppHeader {
                background: #F8F8F8;
                margin: 20px 0;
                padding: 20px 0;
                border-radius: 5px 5px 0 0;
                border: 1px solid #CCC;
                border-bottom: 1px solid #CCC;
                box-shadow: 0 2px 3px rgba(0, 0, 0, 0.2);
            }
            .AppLabel {
                color: #989898;
                font: raleway 18;
                font-weight: normal;
                text-shadow: 0 0 0;
                margin: 20px 0;
            }
            .AppGrid {
                background: #F8F8F8;
                margin: 15px;
                border-radius: 0 0 5px 5px;
                padding: 5px;
                margin: 25px;
                border: 1px solid #CCC;
                border-top: 1px solid #FFF;
                box-shadow: 0 2px 3px rgba(0, 0, 0, 0.2);
            }
            .AppWrapper {
                background: transparent;
                margin: 0;
                border-radius: 0 0 0 0;
                padding: 0;
                margin: 0;
                border: 0 none;
            }
            .AppBottom {
                color: #F8F8F8;
                font-size: 40px;
                border: 0 none;
                margin-top: 0;
                padding-top: 0;
                text-shadow: -1px 0 transparent, 0 1px #CCC, 1px 0 #CCC, 0 -1px #CCC;
            }
            .AppTriangle {
                border-left: 15px solid transparent;
                border-right: 15px solid transparent;
                border-top: 15px solid #F8F8F8;
            }
            GtkButton, GtkEntry
            {
                border: 0 none;
                padding: 15px 0;
                font: inherit;
                outline: inherit;
                background: transparent;
                box-shadow: none;
            }
            """;

        Gtk.CssProvider provider = new Gtk.CssProvider();
        try {
            provider.load_from_data (css, css.length);
        } catch (GLib.Error e) {
            warning("Error while loading css: %s", e.message);
        }
        Gtk.StyleContext.add_provider_for_screen(
            this.get_screen(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION //Gtk.STYLE_PROVIDER_PRIORITY_USER
        );

    	Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default();
        try {
            Gtk.SizeGroup sizegroup = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
            int row = 1;
            int col = 1;
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

                    var button2Box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
                    var labelBtn2 = new Gtk.Label(name);

                    button2Box.pack_start(imgBtn2, false, false, 3);
                    button2Box.pack_start(labelBtn2, false, false, 3);

                    button2.add(button2Box);

                    button2.clicked.connect( ()=> {
                        Posix.system("xdg-open \""+path+"\"");
                        this.close();
                        Gtk.main_quit();
                    });

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

                    button1.clicked.connect( ()=> {
                        Posix.system(command);
                        this.close();
                        Gtk.main_quit();
                    });

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

        //bottom arrow indicator
        Gtk.Box bottomBox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        var bottomArrow = new Gtk.Label("🢓");
        bottomBox.pack_start(bottomArrow);
        box.pack_end(bottomBox);

        //set styles
        this.get_style_context().add_class("AppWindow");
        box.get_style_context().add_class("AppWrapper");
        headerbar.get_style_context().add_class("AppHeader");
        label.get_style_context().add_class("AppLabel");
        this.grid.get_style_context().add_class("AppGrid");
        bottomArrow.get_style_context().add_class("AppBottom");
//        bottomArrow.get_style_context().add_class("AppBottom");
        bottomArrow.set_size_request(1, 1);
        bottomArrow.set_halign(Gtk.Align.CENTER);
        bottomArrow.set_margin_top(0);

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

		string folder_path = Environment.get_home_dir()+"/";
		if (args[1] != null && args[1] != "") {
			folder_path = args[1];
		}

		Application app = new Application(folder_path);

		app.show_all ();
		Gtk.main ();
		return 0;
	}
}
