public class Application : Gtk.Application {

    public Application () {
        Object(application_id: "my.application",
               flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        // create the window of this application and show it
        Gtk.ApplicationWindow window = new Gtk.ApplicationWindow (this);
        window.set_default_size (800, 600);
        window.set_border_width (10);

        // add headerbar with button
        Gtk.HeaderBar headerbar = new Gtk.HeaderBar();
        headerbar.show_close_button = true;
        headerbar.title = "Window";
        window.set_titlebar (headerbar);

        try {
    // Either directly from a file ...
    window.icon = new Gdk.Pixbuf.from_file ("/home/marcelo/Programas/Outros/unnamed.png");

} catch (Error e) {
    stderr.printf ("Could not load application icon: %s\n", e.message);
}

        Gtk.Button button = new Gtk.Button.with_label ("About");
        button.clicked.connect (() => {
            // show about dialog on click
            string[] authors = { "GNOME Documentation Team", null };
            string[] documenters = { "GNOME Documentation Team", null };

            Gtk.show_about_dialog (window,
                                   "program-name", ("GtkApplication Example"),
                                   "copyright", ("Copyright \xc2\xa9 2012 GNOME Documentation Team"),
                                   "authors", authors,
                                   "documenters", documenters,
                                   "website", "http://developer.gnome.org",
                                   "website-label", ("GNOME Developer Website"),
                                   null);
        });
        // add button to headerbar
        headerbar.pack_end (button);

        // create stack
        Gtk.Stack stack = new Gtk.Stack ();
        stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

        // giving widgets to stack
        Gtk.Label label = new Gtk.Label ("A label");
        stack.add_titled (label, "label", "A label");

        Gtk.Label label2 = new Gtk.Label ("Another label");
        stack.add_titled (label2, "label2", "Another label");

        // add stack (contains widgets) to stackswitcher widget
        Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.set_stack (stack);

        // add stackswitcher to vertical box
        Gtk.Box vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        vbox.pack_start (stack_switcher, false, false, 0);
        vbox.pack_start (stack, false, false, 10);

        window.add (vbox);
        window.show_all ();
    }

    public static int main (string[] args) {
        Application app = new Application ();
        return app.run (args);
    }
}
