using Gtk;
using Gdl;

class MainWindow : Window {

    private DockMaster master;
    private DockLayout layout;

    private void save_layout_cb () {
        var dialog = new Dialog.with_buttons ("New Layout", null,
                                              DialogFlags.MODAL |
                                              DialogFlags.DESTROY_WITH_PARENT,
                                              Stock.OK, ResponseType.OK);

        var hbox = new Box (Orientation.HORIZONTAL, 8);
        hbox.border_width = 8;
        var content = dialog.get_content_area ();
        content.pack_start (hbox, false, false, 0);

        var label = new Label ("Name:");
        hbox.pack_start (label, false, false, 0);

        var entry = new Entry ();
        hbox.pack_start (entry, true, true, 0);

        hbox.show_all ();
        var response = dialog.run ();

        if (response == ResponseType.OK) {
            this.layout.save_layout (entry.text);
        }
        dialog.destroy ();
    }

    private void button_dump_cb () {
        try {
            /* Dump XML tree. */
            this.layout.save_to_file ("layout.xml");
            Process.spawn_command_line_async ("cat layout.xml");
        } catch (Error e) {
            stderr.printf ("%s\n", e.message);
        }
    }

    private RadioButton create_style_button (Box box,
                                             RadioButton? group,
                                             SwitcherStyle style,
                                             string style_text)
    {
        var button = new RadioButton.with_label_from_widget (group, style_text);
        button.show ();
        button.active = (this.master.switcher_style == style);
        button.toggled.connect (() => {
            if (button.active) {
                this.master.switcher_style = style;
            }
        });
        box.pack_start (button, false, false, 0);
        return button;
    }

    private Widget create_styles_item (Dock dock) {
        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.show ();

        RadioButton group;
        group = create_style_button (vbox, null, SwitcherStyle.ICON,
                                     "Only icon");
        group = create_style_button (vbox, group, SwitcherStyle.TEXT,
                                     "Only text");
        group = create_style_button (vbox, group, SwitcherStyle.BOTH,
                                     "Both icons and texts");
        group = create_style_button (vbox, group, SwitcherStyle.TOOLBAR,
                                     "Desktop toolbar style");
        group = create_style_button (vbox, group, SwitcherStyle.TABS,
                                     "Notebook tabs");
        return vbox;
    }

    private Widget create_item (string button_title) {
        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.show ();

        var button = new Button.with_label (button_title);
        button.show ();
        vbox.pack_start (button, true, true, 0);

        return vbox;
    }

    /* creates a simple widget with a textbox inside */
    private Widget create_text_item () {
        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.show ();

        var scroll = new ScrolledWindow (null, null);
        scroll.show ();
        vbox.pack_start (scroll, true, true, 0);
        scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll.shadow_type = ShadowType.ETCHED_IN;
        var text = new TextView ();
        text.wrap_mode = WrapMode.WORD;
        text.show ();
        scroll.add (text);

        return vbox;
    }

    public MainWindow () {
        this.destroy.connect (Gtk.main_quit);
        this.title = "Docking widget test";
        set_default_size (400, 400);

        var table = new Box (Orientation.VERTICAL, 5);
        table.border_width = 10;
        add (table);

        /* create the dock */
        var dock = new Dock ();
        this.master = dock.master;

        /* ... and the layout manager */
        this.layout = new DockLayout (dock);

        /* create the dockbar */
        var dockbar = new DockBar (dock);
        dockbar.set_style (DockBarStyle.TEXT);

        var box = new Box (Orientation.HORIZONTAL, 5);
        table.pack_start (box, true, true, 0);

        box.pack_start (dockbar, false, false, 0);
        box.pack_end (dock, true, true, 0);

        /* create the dock items */
        var item1 = new DockItem ("item1", "Item #1", DockItemBehavior.LOCKED);
        item1.add (create_text_item ());
        dock.add_item (item1, DockPlacement.TOP);
        item1.show ();

        var item2 = new DockItem.with_stock ("item2",
                         "Item #2: Select the switcher style for notebooks",
                         Stock.EXECUTE, DockItemBehavior.NORMAL);
        item2.resize = false;
        item2.add (create_styles_item (dock));
        dock.add_item (item2, DockPlacement.RIGHT);
        item2.show ();

        var item3 = new DockItem.with_stock ("item3",
                         "Item #3 has accented characters (áéíóúñ)",
                         Stock.CONVERT,
                         DockItemBehavior.NORMAL | DockItemBehavior.CANT_CLOSE);
        item3.add (create_item ("Button 3"));
        dock.add_item (item3, DockPlacement.BOTTOM);
        item3.show ();

        var items = new DockItem[4];
        items[0] = new DockItem.with_stock ("Item #4", "Item #4",
                                            Stock.JUSTIFY_FILL,
                                            DockItemBehavior.NORMAL |
                                            DockItemBehavior.CANT_ICONIFY);
        items[0].add (create_text_item ());
        items[0].show ();
        dock.add_item (items[0], DockPlacement.BOTTOM);
        for (int i = 1; i < 3; i++) {
            string name = "Item #%d".printf (i + 4);
            items[i] = new DockItem.with_stock (name, name, Stock.NEW,
                                                DockItemBehavior.NORMAL);
            items[i].add (create_text_item ());
            items[i].show ();

            items[0].dock (items[i], DockPlacement.CENTER, 0);
        }

        /* tests: manually dock and move around some of the items */
        item3.dock_to (item1, DockPlacement.TOP, -1);

        item2.dock_to (item3, DockPlacement.RIGHT, -1);

        item2.dock_to (item3, DockPlacement.LEFT, -1);

        item2.dock_to (null, DockPlacement.FLOATING, -1);

        box = new Box (Orientation.HORIZONTAL, 5);
        table.pack_end (box, false, false, 0);

        var button = new Button.from_stock (Stock.SAVE);
        button.clicked.connect (this.save_layout_cb);
        box.pack_end (button, false, true, 0);

        button = new Button.with_label ("Dump XML");
        button.clicked.connect (this.button_dump_cb);
        box.pack_end (button, false, true, 0);

        new DockPlaceholder ("ph1", dock, DockPlacement.TOP, false);
        new DockPlaceholder ("ph2", dock, DockPlacement.BOTTOM, false);
        new DockPlaceholder ("ph3", dock, DockPlacement.LEFT, false);
        new DockPlaceholder ("ph4", dock, DockPlacement.RIGHT, false);
    }
}

void main (string[] args) {
    Gtk.init (ref args);

    var win = new MainWindow ();
    win.show_all ();

    Gtk.main ();
}