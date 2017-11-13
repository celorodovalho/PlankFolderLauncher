using Clutter;

class ClutterDemo {

    private Stage stage;
    private Actor[] rectangles;

    const string[] colors = {
        "blanched almond",
        "OldLace",
        "MistyRose",
        "White",
        "LavenderBlush",
        "CornflowerBlue",
        "chartreuse",
        "chocolate",
        "light coral",
        "medium violet red",
        "LemonChiffon2",
        "RosyBrown3"
    };

    public ClutterDemo () {
        stage = new Stage();
        stage.set_size(512,512);
        stage.background_color = Color () { alpha = 255 };

        rectangles = new Actor[colors.length];
        stage.hide.connect (Clutter.main_quit);

        create_rectangles ();
        stage.show ();
    }

    private void create_rectangles () {
        for (int i = 0; i < colors.length; i++) {
            var r = new Actor();

            r.width = r.height = stage.height / colors.length;
            r.background_color = Color.from_string (colors[i]);

            var point = Point.alloc();
            point.init(0.5f,0.5f) ;
            r.pivot_point = point;

            r.y = i * r.height;

            stage.add_child (r);

            rectangles[i] = r;
        }
    }

    public void start () {
        var transitions = new PropertyTransition[rectangles.length];
        for (int i = 0; i < rectangles.length; i++) {
            var transgroup = new TransitionGroup();
            var transition = new PropertyTransition ("x");
            transition.set_to_value(stage.width/2 - rectangles[i].width/2);
            transition.set_duration(2000);
            transition.set_progress_mode (AnimationMode.LINEAR);
            transgroup.add_transition(transition);

            transition = new PropertyTransition ("rotation_angle_z");
            transition.set_to_value(500.0);
            transition.set_duration(2000);
            transition.set_progress_mode (AnimationMode.LINEAR);
            transgroup.add_transition(transition);

            transgroup.set_duration(2000);
            rectangles[i].add_transition("rectAnimation", transgroup);
            transitions[i] = transition;
        }
        transitions[transitions.length - 1].completed.connect (() => {
                var CONGRATS_EXPLODE_DURATION = 3000;
                var text = new Text.full ("Bitstream Vera Sans 40",
                    "Congratulations!",
                    Color.from_string ("white"));

                var point = Point.alloc();
                point.init(0.5f, 0.5f);
                text.pivot_point = point;
                text.x = stage.width / 2 - text.width / 2;
                text.y = -text.height;    // Off-stage
                stage.add_child (text);


                var transition = new PropertyTransition ("y");
                transition.set_to_value(stage.height/2 - text.height/2);
                transition.set_duration(CONGRATS_EXPLODE_DURATION / 2);
                transition.set_progress_mode(AnimationMode.EASE_OUT_BOUNCE);
                text.add_transition("rectAnimation", transition);

                for (int i = 0; i < rectangles.length; i++) {
                    var transgroup = new TransitionGroup();
                    /* "x" property transition */
                    transition = new PropertyTransition("x");
                    transition.set_to_value(Random.next_double() * stage.width );
                    transition.set_duration(CONGRATS_EXPLODE_DURATION);
                    transgroup.add_transition(transition);
                    transition.set_progress_mode(AnimationMode.EASE_OUT_BOUNCE);

                    /* "y" property transition */
                    transition = new PropertyTransition("y");
                    transition.set_to_value(Random.next_double() * stage.height/2 +
                            stage.height/2);
                    transition.set_duration(CONGRATS_EXPLODE_DURATION);
                    transition.set_progress_mode(AnimationMode.EASE_OUT_BOUNCE);
                    transgroup.add_transition(transition);

                    /* "opacity" property transition */
                    transition = new PropertyTransition("opacity");
                    transition.set_to_value(0);
                    transition.set_duration(CONGRATS_EXPLODE_DURATION );
                    transition.set_progress_mode(AnimationMode.EASE_OUT_BOUNCE);
                    transgroup.add_transition(transition);

                    /* TransitionGroup duration seems to be set explicitely -
                     * at least so large value as the longest duration among
                     * included Transitions */
                    transgroup.set_duration(CONGRATS_EXPLODE_DURATION);
                    transgroup.delay = CONGRATS_EXPLODE_DURATION/3;

                    rectangles[i].add_transition("transbox", transgroup);
                }
        });
    }
}

int main (string[] args) {
    if ( Clutter.init (ref args) < 0) {
        stderr.printf("Failed to initialize clutter\n");
        return 1;
    }
    var demo = new ClutterDemo ();
    demo.start ();
    Clutter.main ();
    return 0;
}