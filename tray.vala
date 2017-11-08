using GLib;
using Gtk;
using Gdk;
using Cairo;

public class test: GLib.Object {

        private StatusIcon trayicon;
        private int old_size;

        // Pixbuf callback to destroy the pixel buffer
        public void PixbufDestroyNotify (uint8* pixels) {

                GLib.stdout.printf("delete buffer\n");
                delete pixels;

        }

        public bool timer() {

                // This callback repaints the systray canvas
                GLib.stdout.printf("repaint\n");
                repaint(this.old_size);
                return false;

        }

        public bool repaint(int size) {

                // First, let's paint something in a Cairo Surface

                var canvas = new Cairo.ImageSurface(Cairo.Format.ARGB32,size,size);
                var ctx = new Cairo.Context(canvas);

                // This makes easier to scale the picture
                ctx.scale(size,size);

                if (size!=old_size) {

                        // When the size changes, paint a red circle
                        ctx.set_source_rgb(1,0,0);

                        // and set a timer to repaint the circle in green after one second
                        GLib.Timeout.add(1000,timer);
                } else {

                        // When just repainting, paint a green circle
                        ctx.set_source_rgb(0,1,0);
                }
                ctx.arc(0.5,0.5,0.3,0,6.283184);
                ctx.set_line_width(0.2);
                ctx.stroke();

                this.old_size=size;

                // the pixel buffer must remain after being created, so manual memory management is used here
                uint8* pixel_data=new uint8[size*size*4];

                // create a new Pixbuf using the previous pixel_data memory as buffer
                // it is 8bit per pixel, RGB, with alpha, and the callback to free the pixel data is PixbufDestroyNotify()
                var pix=new Pixbuf.from_data((uint8[])pixel_data,Gdk.Colorspace.RGB,true,8,size,size,size*4,this.PixbufDestroyNotify);

                uint8 *p1=pixel_data;
                uint8 *p2=canvas.get_data();
                int counter;
                int max=size*size;;

                // Copy the surface to the pixbuf
                // (Format in surface is BGRA, but in Pixbuf is RGBA)
                for(counter=0;counter<max;counter++) {
                        *p1    =*(p2+2);
                        *(p1+1)=*(p2+1);
                        *(p1+2)=*p2;
                        *(p1+3)=*(p2+3);
                        p1+=4;
                        p2+=4;
                }

                // Set pixmap in the systray
                this.trayicon.set_from_pixbuf(pix);

                // Return true because the function had in account the new size, so the pannel has not to scale it
                return true;
        }


        public test() {

                this.old_size=0;
                this.trayicon = new StatusIcon();
                this.trayicon.set_visible(true);

                // This event is called when the user modifies the height of the pannel
                this.trayicon.size_changed.connect(this.repaint);

                // This event is called when the user clicks on the icon.
                // Assigned with an anonymous method to main_quit.
                this.trayicon.activate.connect( () => { Gtk.main_quit(); } );

        }
}

public static int main (string[] args) {

        Gtk.init (ref args);

        var testclass = new test();
        Gtk.main ();
        return 0;
}