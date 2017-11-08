using Gtk;
using Cairo;

/**
 * This example creates a clock with the following features:
 * Shaped window -- Window is unbordered and transparent outside the clock
 * Events are only registered for the window on the hour dots or on the center dot
 * When the mouse is "in" the window (on one of the dots) it will turn green
 *    This helps you understand where the events are actually being registered
 * Clicking allows you to drag the clock.
 * There is currently no code in place to close the window, you must kill the process manually.
 * A Composited environment is required. The python code I copied this from includes checks for this.
 * In my laziness I left them out.
 **/
public class CairoShaped : Gtk.Window {

        // Are we inside the window?
        private bool inside;
        private double cur_x;
        private double cur_y;

        private bool size_valid;
        private bool pos_valid;

        private Pattern grad_in;
        private Pattern grad_out;

        private Surface event_mask;

        private int highlighted;
        private bool[] off_light;
        private double[] hour_x;
        private double[] hour_y;
        private double radius;

        /**
         * Just creating the window, setting things up
         **/
        public CairoShaped () {
                this.title = "Cairo Vala Demo";
                this.destroy.connect (Gtk.main_quit);
                // skip_taskbar_hint determines whether the window gets an icon in the taskbar / dock
                skip_taskbar_hint = true;
                set_default_size (200, 200);
                set_keep_above(true);
                this.inside = false;
                this.size_valid = false;
                this.pos_valid = false;
                this.hour_x = new double[12];
                this.hour_y = new double[12];
                this.highlighted = -1;
                this.off_light = new bool[12];
                for(int i = 0; i < off_light.length;  i++) {
                        off_light[i] = false;
                }

                // We need to register which events we are interested in
                add_events(Gdk.EventMask.BUTTON_PRESS_MASK);
                add_events(Gdk.EventMask.ENTER_NOTIFY_MASK);
                add_events(Gdk.EventMask.LEAVE_NOTIFY_MASK);
                add_events(Gdk.EventMask.SCROLL_MASK);

                // Connecting some events, queue_draw() redraws the window. begin_move_drag sets up the window drag
                enter_notify_event.connect(mouse_entered);
                leave_notify_event.connect(mouse_left);
                button_press_event.connect(button_pressed);
                scroll_event.connect(scrolled);

                // Turn off the border decoration
                set_decorated(false);
                set_app_paintable(true);

                // Need to get the rgba colormap or transparency doesn't work.
                set_visual(screen.get_rgba_visual());

                // The expose event is what is called when we need to draw the window
                draw.connect(on_expose);
        }

        public bool mouse_entered(Gdk.EventCrossing e) {
                cur_x = e.x;
                cur_y = e.y;
                inside = true;
                pos_valid = false;
                queue_draw();
                return true;
        }

        public bool mouse_left(Gdk.EventCrossing e) {
                cur_x = -100;
                cur_y = -100;
                inside = false;
                pos_valid = false;
                queue_draw();
                return true;
        }

        public bool button_pressed(Gdk.EventButton e) {
                if(e.button == 2) {
                        destroy();
                } else {
                        if(highlighted >= 0) {
                                off_light[highlighted] = !off_light[highlighted];
                        }
                        begin_move_drag((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
                }
                return true;
        }

        public bool scrolled(Gdk.EventScroll e) {
                int width;
                int height;
                get_size(out width, out height);
                int x;
                int y;
                get_position(out x, out y);
                if(e.direction == Gdk.ScrollDirection.UP) {
                        resize(width + 4, height + 4);
                        move(x-2, y-2);
                        size_valid = false;
                        queue_draw();
                } else if(e.direction == Gdk.ScrollDirection.DOWN) {
                        resize(width - 4, height - 4);
                        move(x+2, y+2);
                        size_valid = false;
                        queue_draw();
                }
                return true;
        }

        private void create_gradients() {
                int width;
                int height;
                get_size(out width, out height);

                width >>= 1;
                height >>= 1;

                radius = width;

                grad_in = new Cairo.Pattern.radial(width,height,0,width,height,radius);

                grad_in.add_color_stop_rgba(0.0, c(10), c(190), c(10), 1.0);
                grad_in.add_color_stop_rgba(0.8, c(10), c(190), c(10), 0.7);
                grad_in.add_color_stop_rgba(1.0, c(10), c(190), c(10), 0.5);

                grad_out = new Cairo.Pattern.radial(width, height, 0, width, height, radius);

                grad_out.add_color_stop_rgba(0.0, c(10), c(10), c(190), 1.0);
                grad_out.add_color_stop_rgba(0.8, c(10), c(10), c(190), 0.7);
                grad_out.add_color_stop_rgba(1.0, c(10), c(10), c(190), 0.5);

        }

        private void create_mask() {
                int width;
                int height;
                get_size(out width, out height);

                event_mask = new ImageSurface(Format.ARGB32, width, height);
                // Get a context for it
                var pmcr = new Context(event_mask);

                // Initially we want to blank out everything in transparent as we
                // Did initially on the ctx context
                pmcr.set_source_rgba(1.0,1.0,1.0,0.0);
                pmcr.set_operator(Operator.SOURCE);
                pmcr.paint();

                // Now the areas that should receive events need to be made opaque
                pmcr.set_source_rgba(0,0,0,1);

                // Here we copy the motions to draw the middle dots and the hour dots.
                // This is mostly to demonstrate that you can make this any shape you want.
                pmcr.arc(width >> 1, height >> 1, width / 20.0, 0, 2.0*3.14);
                pmcr.fill();
                pmcr.stroke();

                for(int i = 0; i < 12; i++) {
                        pmcr.arc(hour_x[i],hour_y[i],width / 40.0,0,2.0 * 3.14);
                        pmcr.fill();
                        pmcr.stroke();
                }
                input_shape_combine_region(Gdk.cairo_region_create_from_surface(event_mask));
        }

        private void locate_dots() {
                int width;
                int height;
                get_size(out width, out height);

                width >>= 1;
                height >>= 1;

                for(int i = 0; i < 12; i++) {
                        hour_x[i] = width + 0.9 * width * Math.cos(2.0 * 3.14 * (i/12.0));
                        hour_y[i] = height + 0.9 * height * Math.sin(2.0 * 3.14 * (i/12.0));
                }
        }

        private void find_highlight() {
                double rad = radius/ 20.0;
                for(int i = 0; i < 12; i++) {
                        if((Math.fabs(hour_x[i] - cur_x) <= rad + 2) && (Math.fabs(hour_y[i] - cur_y) <= rad + 2)) {
                                highlighted = i;
                                return;
                        }
                }
                highlighted = -1;
        }

        /**
         * Actual drawing takes place within this method
         **/
        private bool on_expose (Context ctx) {
                if(!size_valid) {
                        create_gradients();
                        locate_dots();
                        create_mask();
                        size_valid = true;
                }

                if(!pos_valid) {
                        find_highlight();
                        pos_valid = true;
                }


                // This makes the current color transparent (a = 0.0)
                ctx.set_source_rgba(1.0,1.0,1.0,0.0);

                // Paint the entire window transparent to start with.
                ctx.set_operator(Cairo.Operator.SOURCE);
                ctx.paint();

                // Set the gradient as our source and paint a circle.
                if(inside) {
                        ctx.set_source(grad_in);
                } else {
                        ctx.set_source(grad_out);
                }
                ctx.arc(radius, radius, radius, 0, 2.0*3.14);
                ctx.fill();
                ctx.stroke();

                // This chooses the color for the hour dots
                if(inside) {
                        ctx.set_source_rgba(0.0,0.2,0.6,0.8);
                } else {
                        ctx.set_source_rgba(c(226), c(119), c(214), 0.8);
                }

                double rad = radius / 20.0;

                // Draw the 12 hour dots.
                for(int i = 0; i < 12; i++) {
                        double x = hour_x[i];
                        double y = hour_y[i];

                        if(i == highlighted) {
                                var s = ctx.get_source();
                                ctx.set_source_rgba(c(233), c(120), c(20), 0.8);
                                ctx.arc(x,y,rad,0,2.0 * 3.14);
                                ctx.fill();
                                ctx.stroke();
                                ctx.set_source(s);
                        } else if(!inside && off_light[i]) {
                                var s = ctx.get_source();
                                ctx.set_source_rgba(c(216), c(215), c(44), 0.8);
                                ctx.arc(x,y,rad,0,2.0 * 3.14);
                                ctx.fill();
                                ctx.stroke();
                                ctx.set_source(s);
                        } else {
                                ctx.arc(x,y,rad,0,2.0 * 3.14);
                                ctx.fill();
                                ctx.stroke();
                        }
                }

                // This is the math to draw the hands.
                // Nothing overly useful in this section
                ctx.move_to(radius, radius);
                ctx.set_source_rgba(0, 0, 0, 0.8);

                Time t = Time.local(time_t());
                int hour = t.hour;
                int minutes = t.minute;
                int seconds = t.second;
                double per_hour = (2 * 3.14) / 12;
                double dh = (hour * per_hour) + ((per_hour / 60) * minutes);
                dh += 2 * 3.14 / 4;
                ctx.set_line_width(0.05 * radius);
                ctx.rel_line_to(-0.5 * radius * Math.cos(dh), -0.5 * radius * Math.sin(dh));
                ctx.move_to(radius, radius);
                double per_minute = (2 * 3.14) / 60;
                double dm = minutes * per_minute;
                dm += 2 * 3.14 / 4;
                ctx.rel_line_to(-0.9 * radius * Math.cos(dm), -0.9 * radius * Math.sin(dm));
                ctx.move_to(radius, radius);
                double per_second = (2 * 3.14) / 60;
                double ds = seconds * per_second;
                ds += 2 * 3.14 / 4;
                ctx.rel_line_to(-0.9 * radius * Math.cos(ds), -0.9 * radius * Math.sin(ds));
                ctx.stroke();

                // Drawing the center dot
                ctx.set_source_rgba(c(124), c(32), c(113), 0.7);

                ctx.arc(radius, radius, 0.1 * radius, 0, 2.0*3.14);
                ctx.fill();
                ctx.stroke();

                return true;
        }

        private double c(int val) {
                return val / 255.0;
        }

        static int main (string[] args) {
                Gtk.init (ref args);

                var cairo_sample = new CairoShaped ();
                cairo_sample.show_all ();

                // Just a timeout to update once a second.
                Timeout.add_seconds(1,()=>{cairo_sample.queue_draw();return true;});

                Gtk.main ();

                return 0;
        }
}
