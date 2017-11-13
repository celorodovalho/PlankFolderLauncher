using Gtk;
using Posix;

public class Application : Gtk.Window {
    private Gtk.Grid grid;
    private Gtk.Widget btnCurrent;
	public Application (string folder_path) {
		// Prepare Gtk.Window:
		//this.title = "My Gtk.Image";
		this.window_position = Gtk.WindowPosition.MOUSE;
		this.destroy.connect (Gtk.main_quit);
		//this.skip_taskbar_hint = true;
		//this.set_default_size (350, 70);
		//this.set_app_paintable(true);
		//this.set_decorated(false);
		//this.set_opacity(0.8);
		//this.set_default_size (450, 450);

	//var header = new Gtk.HeaderBar ();
    //header.title = "ElementaryOS";
    /*header.show_close_button = true;
    header.subtitle = "An ElementaryOS App";
    header.spacing = 0;
    this.set_titlebar(header);*/
    int x, y;
    this.get_position(out x, out y);
    int z = 500;
    this.move(x-95, 400);

		base.set_border_width(0);

		//var css = GLib.File.new_for_path ("app.css");
		//var css = GLib.File.new_for_uri("resource://home/marcelo/Projetos/plankfolderlauncher/app.css");
		//var provider = new Gtk.CssProvider();
		//var file = GLib.File.new_for_uri ("resource://home/marcelo/Projetos/plankfolderlauncher/app.css");
		//provider.load_from_path("app.css");
		//provider.load_from_data(".test-bg {background-color: #FFF;}");
		/*provider.load_from_resource ("~/Projetos/plankfolderlauncher/app.css");
		Gtk.StyleContext.add_provider_for_screen (
        	this.get_screen(),
        	provider,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);*/

		/*try
        {
            if (provider.load_from_file (file))
            {
                Gtk.StyleContext.add_provider_for_screen (
                	this.get_screen(),
                	provider,
					Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
				);
            }
        }
        catch (Error e)
        {
            warning ("Error while loading css: %s", e.message);
        }*/


		/*Gtk.StyleContext.add_provider_for_screen(
			Gdk.Screen.get_default(),
			provider,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);*/

		//this.get_style_context().add_class("test-bg");
		//Gtk.StyleContext style = base.get_style_context();
		//style.set_background_color();
		//base.set_style(9);

		// The image:
		// Gtk.Image image = new Gtk.Image ();
		//Gtk.Image image = new Gtk.Image.from_icon_name ("gnome-panel-launcher", Gtk.IconSize.DND);
		/*var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
		hbox.homogeneous = true;*/
		var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);


//		box.set_border_width(30);
//		box.set_border_width(30);
		var grid = new Gtk.Grid ();
        this.grid = grid;
		grid.set_column_spacing(2);
        grid.set_row_spacing(2);
        //grid.set_baseline_row(4);
		//grid.set_column_homogeneous(true);
		//grid.set_margin_top(50);
		grid.get_style_context().add_class("grid-bg");
		this.get_style_context().add_class("main-window");
//		var icons = 5;


    	Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default();
    	/*
        found_icons = set()
        for res in range(0, 512, 2):
            icon = theme.lookup_icon(icon_name, res, 0)
            if icon:
                found_icons.add(icon.get_filename())

        if found_icons:
            print("\n".join(found_icons))
        else:
                print(icon_name, "was not found")*/
//        File docsets = File.new_for_path (Environment.get_home_dir () + "/.local/share/zeal/docsets");
//        File docsets = File.new_for_path (folder_path);
        Gtk.SizeGroup sizegroup = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        var i = 0;
        var row = 1;
        var col = 1;
        try {
            string directory = folder_path;
            GLib.Dir dir = GLib.Dir.open (directory, 0);
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
                GLib.stdout.printf ("path: %s %s\t%s\n", path, name, type);
                if (col % 4 == 0) {
                    grid.insert_row(row+1);
                    col = 1;
                    row++;
                }

//                var icon = new Gtk.Image.from_icon_name ("usb-creator-gtk", Gtk.IconSize.DND);
//                var icon = new Gtk.Image.from_file(name);
                if (FileUtils.test (path, FileTest.IS_DIR)) {
                    //Gtk.Button button2 = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.DND);
                    Gtk.Image imgBtn2 = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.DND);
                    Gtk.Button button2 = new Gtk.Button();
                    //Gtk.Button button2 = new Gtk.Button();
                    button2.get_style_context().add_class("button");

                    var button2Box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
                    var labelBtn2 = new Gtk.Label(name);

                    button2Box.pack_start(imgBtn2, false, false, 3);
                    button2Box.pack_start(labelBtn2, false, false, 3);

                    button2.add(button2Box);

                    //image.show();
                    //label.show();

                    button2.clicked.connect( ()=> { Posix.system("xdg-open \""+path+"\""); });


                    this.grid_attach (button2, col, row, 1, 1);
                    sizegroup.add_widget(button2);
                }
                if (!FileUtils.test (path, FileTest.IS_DIR)) {
                    string read;
                    string arquivo = folder_path+"/"+name;
                    FileUtils.get_contents (arquivo, out read);

                    //stdout.printf ("The content of file '%s' is:\n%s\n", arquivo, read);
                    string[] string_split = read.split ("\n");
                    string iconname = "";
                    string appname = "";
                    string command = "";
                    foreach(var strplit in string_split) {
                        //stdout.printf ("The content of file '%s'\n", strplit);
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
                    GLib.stdout.printf ("ICONNAME '%s'\n", iconname);
                    Gtk.Button button1 = new Gtk.Button();
                    button1.get_style_context().add_class("button");

                    var button1Box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
                    var labelBtn1 = new Gtk.Label(appname);

			        Gtk.IconInfo? icon_info = icon_theme.lookup_icon (iconname, 48, 0);
                    if(icon_info != null) {
                        var icon = new Gtk.Image.from_icon_name (iconname, Gtk.IconSize.DND);
//                        Gdk.Pixbuf pixbuf = icon_info.load_icon ();
//                        icon = new Gtk.Image.from_pixbuf (pixbuf);
                        //button1.set_image(icon);
                        button1Box.pack_start(icon, false, false, 3);
                    } else {
                        //var icon = new Gtk.Image.from_file (iconname);
                        Gdk.Pixbuf iconPix = new Gdk.Pixbuf.from_file_at_size(iconname, 32, 32);
                        var icon = new Gtk.Image.from_pixbuf(iconPix);
                        //icon.get_style_context().add_class("image");
                        //button1.set_image(icon);
                        button1Box.pack_start(icon, false, false, 3);
                    }
                    
                    button1Box.pack_start(labelBtn1, false, false, 3);

                    button1.add(button1Box);

                    button1.clicked.connect( ()=> { Posix.system(command); });

//                    var box2 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

//                    var w = 15;
//                    var h = 15;
//                    box2.adjust_size_request(Gtk.Orientation.VERTICAL,w,h);
                    GLib.stdout.printf ("COL '%d' ROW '%d' \n ", col, row);
                    this.grid_attach (button1, col, row, 1, 1);
                    sizegroup.add_widget(button1);
                }

                col++;
            }
        } catch (FileError err) {
            GLib.stderr.printf (err.message);
        } catch (GLib.Error err) {
            GLib.stderr.printf (err.message);
        }


//		if (img_path != "") {
//			image.set_from_file (img_path);
//		}
        box.add(grid);
		//box.resize_children();
		this.add (box);
	}

    public void grid_attach (Gtk.Widget button2, int left, int top, int width, int height) {
        if (left == 1) {
            this.grid.attach (button2, left, top, width, height);
        } else {
            //var btn = this.grid.get_child_at(left, top);
            this.grid.attach_next_to (button2, this.btnCurrent, Gtk.PositionType.RIGHT, width, height);
        }
        this.btnCurrent = button2;
    }

	public static int main (string[] args) {
		Gtk.init (ref args);

		var css_provider = new Gtk.CssProvider();
		try {
            //css_provider.load_from_path(Environment.get_current_dir ()+"/app.css");
    		css_provider.load_from_path(Environment.get_home_dir()+"/Projetos/plankfolderlauncher/app.css");
    	} catch (GLib.Error e) {
        		warning ("Error while loading css: %s", e.message);
    	}

        //GLib.stdout.printf ("CSS: %s", Environment.get_current_dir ());

        //string folder_path = "/home/marcelo/Projetos/teste/";
		string folder_path = "";
		if (args[1] != null) {
			folder_path = args[1];
		}

		Application app = new Application (folder_path);


		Gtk.StyleContext.add_provider_for_screen (
        		app.get_screen(),//this.get_screen(),
        		css_provider,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);
		app.get_style_context().add_class("main-window");


		app.show_all ();
		Gtk.main ();
		return 0;
	}
}
