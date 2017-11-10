public class Application : Gtk.Window {
	public Application (string img_path) {
		// Prepare Gtk.Window:
		//this.title = "My Gtk.Image";
		this.window_position = Gtk.WindowPosition.CENTER;
		this.destroy.connect (Gtk.main_quit);
		this.skip_taskbar_hint = true;
		//this.set_default_size (350, 70);
		this.set_app_paintable(true);
		this.set_decorated(false);
		//this.set_opacity(0.8);
		
	//var header = new Gtk.HeaderBar ();
    //header.title = "ElementaryOS";
    /*header.show_close_button = true;
    header.subtitle = "An ElementaryOS App";
    header.spacing = 0;
    this.set_titlebar(header);*/

		base.set_border_width(20);

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
		Gtk.Image image = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.DND);
		/*var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
		hbox.homogeneous = true;*/
		var grid = new Gtk.Grid ();
		grid.get_style_context().add_class("test-bg");
		this.get_style_context().add_class("main-window");
		var icons = 5;
    	var i = 1;
		for (i = 1;i<=icons;i++) {
		    var icon = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.DND);
		    grid.attach (icon, i, i, i, i);
		}

		if (img_path != "") {
			image.set_from_file (img_path);
		}
		this.add (grid);
	}

	public static int main (string[] args) {
		Gtk.init (ref args);

		var css_provider = new Gtk.CssProvider();
		try
        {
        	css_provider.load_from_path("app.css");
        }
        catch (GLib.Error e)
        {
            warning ("Error while loading css: %s", e.message);
        }



		string img_path = "";
		if (args[1] != null) {
			img_path = args[1];
		}

		Application app = new Application (img_path);


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