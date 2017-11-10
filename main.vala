// This is Vala Code!

using Gtk;

class ElementaryFileViewer : Window {
//  TextView text_view;

  ElementaryFileViewer () {
    /*var header = new HeaderBar ();
    //header.title = "ElementaryOS";
    header.show_close_button = true;
    header.subtitle = "An ElementaryOS App";
    header.spacing = 0;*/

    window_position = WindowPosition.CENTER;
//    set_titlebar(false);
    skip_taskbar_hint = true;
//    set_default_size (200, 200);
//    set_keep_above(true);
    set_decorated(false);
//    set_modal(true);
    set_opacity(0.5);
    set_app_paintable(true);
//    File docsets = File.new_for_path (Environment.get_home_dir () + "/.local/share/zeal/docsets");
//    string textFinal = "";
//    try {
//        string directory = "./";
//        Dir dir = Dir.open (directory, 0);
//        string? name = null;
//
//        while ((name = dir.read_name ()) != null) {
//            string path = Path.build_filename (directory, name);
//            string type = "";
//            textFinal += "\r\n"+path;
//            if (FileUtils.test (path, FileTest.IS_REGULAR)) {
//                type += "| REGULAR ";
//            }
//            if (FileUtils.test (path, FileTest.IS_SYMLINK)) {
//                type += "| SYMLINK ";
//            }
//            if (FileUtils.test (path, FileTest.IS_DIR)) {
//                type += "| DIR ";
//            }
//            if (FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
//                type += "| EXECUTABLE ";
//            }
//            stdout.printf ("%s\t%s\n%s", name, type, textFinal);
//        }
//    } catch (FileError err) {
//        stderr.printf (err.message);
//    }

//    this.add (new Gtk.Label (textFinal));

//    set_default_size (500, 600);
//    border_width = 2;

//    var dialog = new Gtk.MessageDialog(null,Gtk.DialogFlags.MODAL,Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Hello from Vala!");
//    dialog.set_title("Message Dialog");
//    dialog.run();
//    dialog.destroy();


    var open_icon = new Image.from_icon_name ("document-open", IconSize.LARGE_TOOLBAR); // Explicit Typing
//    var open_button = new ToolButton (open_icon, "Open");
//    open_button.is_important = true;
//    open_button.clicked.connect (on_open_clicked);
    //header.add (open_button);

//    text_view = new TextView ();
//    text_view.editable = false;
//    text_view.cursor_visible = false;
//
//    text_view.buffer.text = textFinal;

    /*var scroll = new ScrolledWindow (null, null);
    scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
//    scroll.add (text_view);
    var icons = 5;
    var i = 1;
    for (i = 1;i<=icons;i++) {
        var icon = new Image.from_icon_name ("document-open", IconSize.LARGE_TOOLBAR);
        scroll.add (icon);
    }
    scroll.add (open_icon);*/

    /*var vbox = new Box (Orientation.VERTICAL, 0);
    vbox.set_app_paintable(true);
    //vbox.pack_start (scroll, true, true, 0);
    vbox.pack_start (open_icon, true, true, 0);*/
    add (open_icon);
  }

//  void on_open_clicked () {
//    var file_chooser = new FileChooserDialog ("Open File", this,
//                                  FileChooserAction.OPEN,
//                                  "_Cancel", ResponseType.CANCEL,
//                                  "_Open", ResponseType.ACCEPT);
//    if (file_chooser.run () == ResponseType.ACCEPT) {
//      open_file (file_chooser.get_filename ());
//    }
//    file_chooser.destroy ();
//  }

//  void open_file (string filename) {
//    try {
//      string text;
//      FileUtils.get_contents (filename, out text);
//      this.text_view.buffer.text = text;
//    } catch (Error e) {
//      stderr.printf ("Error: %s\n", e.message);
//    }
//  }

  static int main (string[] args) {
    init (ref args);

    var window = new ElementaryFileViewer ();
    window.destroy.connect (main_quit);
    window.show_all ();

    Gtk.main ();
    return 0;
  }
}
