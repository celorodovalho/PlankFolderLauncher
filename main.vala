int main(string[] args) {
    Gtk.init(ref args);

    var header = new Gtk.HeaderBar();
    header.set_show_close_button(true);

    var window = new Gtk.Window();
    window.set_titlebar(header);
    window.destroy.connect(Gtk.main_quit);
    window.set_default_size(350, 70);
    window.border_width = 10;

    var myButton = new Gtk.Button.with_label("Hello world!");

    window.add(myButton);
    window.show_all();

    Gtk.main();
    return 0;
}