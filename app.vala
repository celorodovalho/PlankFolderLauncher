using Gtk;

public class Application : Gtk.Window {
	public Application (string folder_path) {
		// Prepare Gtk.Window:
		//this.title = "My Gtk.Image";
		this.window_position = Gtk.WindowPosition.CENTER;
		this.destroy.connect (Gtk.main_quit);
		//this.skip_taskbar_hint = true;
		//this.set_default_size (350, 70);
		//this.set_app_paintable(true);
		//this.set_decorated(false);
		//this.set_opacity(0.8);
		this.set_default_size (450, 450);

	//var header = new Gtk.HeaderBar ();
    //header.title = "ElementaryOS";
    /*header.show_close_button = true;
    header.subtitle = "An ElementaryOS App";
    header.spacing = 0;
    this.set_titlebar(header);*/

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
		grid.set_column_spacing(2);
		grid.set_row_spacing(2);
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
        var i = 1;
        try {
            string directory = folder_path;
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

//                var icon = new Gtk.Image.from_icon_name ("usb-creator-gtk", Gtk.IconSize.DND);
//                var icon = new Gtk.Image.from_file(name);
                if (!FileUtils.test (path, FileTest.IS_DIR)) {
                    string read;
                    string arquivo = folder_path+"/"+name;
                    FileUtils.get_contents (arquivo, out read);

                    //stdout.printf ("The content of file '%s' is:\n%s\n", arquivo, read);
                    string[] string_split = read.split ("\n");
                    string iconname = "";
                    foreach(var strplit in string_split) {
                        //stdout.printf ("The content of file '%s'\n", strplit);
                        if(strplit.has_prefix("Icon=")) {
                            iconname = strplit.replace("Icon=", "");
                        }
                    }
//                        stdout.printf ("The content of file '%s'\n", );
                    Gtk.Button button1 = new Gtk.Button();
                    button1.get_style_context().add_class("button");

			        Gtk.IconInfo? icon_info = icon_theme.lookup_icon (iconname, 48, 0);
                    if(icon_info != null) {
                        var icon = new Gtk.Image.from_icon_name (iconname, Gtk.IconSize.DND);
//                        Gdk.Pixbuf pixbuf = icon_info.load_icon ();
//                        icon = new Gtk.Image.from_pixbuf (pixbuf);
                        button1.set_image(icon);
                    } else {
                        var icon = new Gtk.Image.from_file (iconname);
                        icon.set_size_request (3,3);
                        icon.get_style_context().add_class("image");
                        button1.set_image(icon);
                    }

g
//                    var box2 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

//                    var w = 15;
//                    var h = 15;
//                    box2.adjust_size_request(Gtk.Orientation.VERTICAL,w,h);

                    grid.attach (button1, i+1, 1, 20, 1);
                    sizegroup.add_widget(button1);
                }

                i++;
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }


//		if (img_path != "") {
//			image.set_from_file (img_path);
//		}
		box.add(grid);
		this.add (box);
	}

	public static int main (string[] args) {
		Gtk.init (ref args);

		var css_provider = new Gtk.CssProvider();
		try {
        		css_provider.load_from_path("app.css");
        	} catch (GLib.Error e) {
            		warning ("Error while loading css: %s", e.message);
        	}

		string folder_path = "/home/marcelo/Projetos/teste/";
//		if (args[1] != null) {
//			img_path = args[1];
//		}

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
